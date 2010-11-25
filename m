Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0KYKmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:42:03 -0500
Received: from 193-34-3-90.chelmnet.pl ([193.34.3.90]:39256 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0KYKmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:42:02 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 05:42:02 EST
Date: Thu, 25 Nov 2010 11:32:59 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Subject: Re: VFS support for fast copy on deduplicating FSes
Message-ID: <20101125103258.GA16562@mother.pipebreaker.pl>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
References: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 04:19:17AM -0600, David Nicol wrote:
> unresearched question/suggestion:
> 
> Is there general support for a "fast copy" ioctl in the VFS layer,
> which would be hooked by file systems that support COW or other forms
> of deduplication and can provide copy semantics by manipulating
> metadata only?
> 

  Yes, see reflink(2) syscall (http://lwn.net/Articles/331576/).

-- 
Tomasz Torcz                "Funeral in the morning, IDE hacking
xmpp: zdzichubg@chrome.pl    in the afternoon and evening." - Alan Cox

