Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532Ab0JGOw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:52:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49834 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab0JGOwz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:1:1>);
	Thu, 7 Oct 2010 10:52:55 -0400
Message-Id: <4CADFAE6020000780001B4DC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 07 Oct 2010 15:52:54 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: patch disabling use of PSE on Atom CPUs with a certain
	 erratum
References: <4CADAB3A020000780001B30A@vpn.id2.novell.com>
 <4CADCF23.5070800@zytor.com> <4CADEED9020000780001B44F@vpn.id2.novell.com>
 <4CADD442.4050706@zytor.com>
In-Reply-To: <4CADD442.4050706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.10.10 at 16:08, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 10/07/2010 07:01 AM, Jan Beulich wrote:
>>>
>>> Those Atoms don't have 64-bit support.
>> 
>> That's different from what I found looking around on the web.
>> 
> 
> Do tell...

E.g.

http://en.wikipedia.org/wiki/List_of_Intel_Atom_microprocessors

in particular the Atom 230 and Atom 330 (which to my reading match
the spec updates for the 200 and 300 series, which in turn exhibit
the erratum in question).

Jan

