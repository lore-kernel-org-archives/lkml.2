Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1EOIJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:09:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61225 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1EOIJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B8jTPtzcq2iZ0HiTk2Og8BMsNVUqdMFem9JANltBAVhQkvmKyhpWXiwBI7dOSwGA+d
         QCH0MqkWV14mAAPceW3FaOnatgmaLM67pGbnAbix7aSgsUatbpYZZRNHBep+p4aZcKZI
         +26TIja+MFz9qWUHKvZW6vblYLfhlqTj1P0xw=
Date: Sun, 15 May 2011 11:09:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: bskeggs@redhat.com
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org
Subject: Re: 2.6.39-rc7 nouveau vs KDE 4.6.2
Message-ID: <20110515080929.GA2533@p183>
References: <20110514231208.GA2947@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514231208.GA2947@p183>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 02:12:08AM +0300, Alexey Dobriyan wrote:
> After logging into KDE, I get garbage areas when say mouse moves over
> icon in tray, or when window is opened fullscreen to the point it's
> unusable.
> 
> Previous version of KDE (4.4.5?) was OK.
> 
> 
> Linux version 2.6.39-rc7 (ad@p183) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #4 SMP PREEMPT Tue May 10 22:07:32 EEST 2011

FYI, 2.6.38.5 is no different.
