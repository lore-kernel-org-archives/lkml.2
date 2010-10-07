Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638Ab0JGNqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:46:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42555 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760598Ab0JGNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:46:15 -0400
Message-ID: <4CADCF23.5070800@zytor.com>
Date: Thu, 07 Oct 2010 06:46:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: patch disabling use of PSE on Atom CPUs with a certain erratum
References: <4CADAB3A020000780001B30A@vpn.id2.novell.com>
In-Reply-To: <4CADAB3A020000780001B30A@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 02:12 AM, Jan Beulich wrote:
> In commit 7a0fc404ae663776e96db43879a0fa24fec1fa3a you
> disable use of PSE, but I wonder how this can take any effect on
> 64-bit CPUs, as they use large pages during early boot already.
> Those pages, when use of PSE gets disabled, will get broken up
> into 4k pages in phys_pmd_init(), thus actually increasing the
> chances that you hit the erratum.
> 
> What am I missing?
> 

Those Atoms don't have 64-bit support.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

