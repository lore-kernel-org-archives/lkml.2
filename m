Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab0JGOBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:01:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:59433 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab0JGOBb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:1:1>);
	Thu, 7 Oct 2010 10:01:31 -0400
Message-Id: <4CADEED9020000780001B44F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 07 Oct 2010 15:01:29 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: patch disabling use of PSE on Atom CPUs with a certain
	 erratum
References: <4CADAB3A020000780001B30A@vpn.id2.novell.com>
 <4CADCF23.5070800@zytor.com>
In-Reply-To: <4CADCF23.5070800@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.10.10 at 15:46, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 10/07/2010 02:12 AM, Jan Beulich wrote:
>> In commit 7a0fc404ae663776e96db43879a0fa24fec1fa3a you
>> disable use of PSE, but I wonder how this can take any effect on
>> 64-bit CPUs, as they use large pages during early boot already.
>> Those pages, when use of PSE gets disabled, will get broken up
>> into 4k pages in phys_pmd_init(), thus actually increasing the
>> chances that you hit the erratum.
>> 
>> What am I missing?
>> 
> 
> Those Atoms don't have 64-bit support.

That's different from what I found looking around on the web.

Jan

