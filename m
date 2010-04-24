Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0DXMOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 08:14:09 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:61426 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0DXMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 08:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=UtcbogTgGKnlaIRSd9K6lkNxcUSoJX1qnYrUlx6yUTXhNEpgTP6CFthNZ+3o193td6
         ZjrRhENjoOlp/hwAr+exyg5WdLprlkd+jAbMA78tmM+EX8vghE8LjeB6gEN7lzu29O6Y
         0/HncV5+YD3remkRGFryBjL2G82RyNFfCmyMk=
Date: Sat, 24 Apr 2010 14:13:47 +0200
From: Dan Carpenter <error27@gmail.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Message-ID: <20100424121347.GN29093@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Pedro Francisco <pedrogfrancisco@gmail.com>,
	linux-kernel@vger.kernel.org
References: <201004230806.13628.pedrogfrancisco@gmail.com> <20100423191342.GI29093@bicker> <201004241027.01241.pedrogfrancisco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004241027.01241.pedrogfrancisco@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 10:27:00AM +0100, Pedro Francisco wrote:
> A Sexta, 23 de Abril de 2010 20:13:42 Dan Carpenter escreveu:
> > On Fri, Apr 23, 2010 at 08:06:13AM +0100, Pedro Francisco wrote:
> -snip
> > > 
> > > Is it possible a faulty ath5k module to affect diverse parts of kernel
> > > causing different oopses to happen referencing things as different as
> > > cdrom_ioctl, find_vma, i915_gem_object_get_pages,
> > > get_vfs_caps_from_disk,
> > > warn_slowpath_common (ath5k_tasklet_rx), proc_lookup_de and
> > > _spin_lock(ext4_getattr) [soft lookup]?
> > 
> -snip
> > 
> > If you know a working version of the kernel try a git bisect otherwise
> > just post your dmesg with the crash etc.
> > 
> 
> I don't. I doubt the dmesg will be of significance, as I said they're never the 
> same.
> However I've posted the dmesgs here [ 
> http://ubuntuforums.org/showthread.php?t=1457568 ] prior to asking for help in 
> LKML. Kernel version is Ubuntu's 2.6.32, not Vanilla.
> 
> I believe nothing significant can be extracted from them. Am I correct?
> 

Well they have the 'M' taint for "Machine Check Exception" so that
probably means the hardware is failing.

regards,
dan carpenter

> -- 
> Pedro
