Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0E1Tbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:31:50 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:45883 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754996Ab0E1Tbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:31:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TKXVR245958/0N+/e28Zo+5Zx5y+BwPnV8pU6ihKbK91u+sD6wPbktMjpkVI3B+5XlVEyauey6tFkEw5rwzUjXXw1Jkn4BJb4MW1m/Tv7XI05Bl085FlTYwZ1o3PlhPe;
Date: Fri, 28 May 2010 12:28:11 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not
 already assigned
Message-ID: <20100528122811.3ff8decc@virtuousgeek.org>
In-Reply-To: <4BFFF8F8.1070502@sgi.com>
References: <4BEAF008.9030805@sgi.com>
	<4BFFF517.6040401@sgi.com>
	<4BFFF6B8.30005@zytor.com>
	<4BFFF8F8.1070502@sgi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 10:10:16 -0700
Mike Travis <travis@sgi.com> wrote:

> 
> 
> H. Peter Anvin wrote:
> > On 05/28/2010 09:53 AM, Mike Travis wrote:
> >> Any further consideration for this patch, or has it been rejected?
> > 
> > Well, it's really up to Jesse, but as far as I can see, this patch is a
> > net loss of functionality and doesn't actually add anything.  Without
> > this patch, some resources that were not assigned by BIOS will be
> > unreachable.  With this patch, *all* resources that were not assigned by
> > BIOS will be unreachable...
> > 
> > 	-hpa
> > 
> 
> Apparently you're missing the point of the patch?  The patch is needed
> because BIOS is purposely not assigning I/O BAR's to devices that won't
> use them, freeing up the resource for devices that do need them.  Where
> is the "all" resources that are not reachable?

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
