Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1AYEUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 23:20:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54931 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1AYEUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 23:20:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YqBPR0oQ4f2Jgy1SHxfgxh70gewD0FheupjjZG81GtKKNbn6UHkRK8qRdCVNKcTh3e
         yWE3wYjsa4n1neDQsGqfDIbIc8yckY4rAC4TVDhOlhHi/WxNgg02vC5N5ELtp85u9i9X
         H+axcE5ekCRbo5EfNhdtZCQtXTNDDn+rQROMo=
Date: Mon, 24 Jan 2011 20:20:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125042016.GA7850@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
 <20110124175456.GA17855@core.coreip.homeip.net>
 <4D3E1A08.5060303@teksavvy.com>
 <20110125005555.GA18338@core.coreip.homeip.net>
 <4D3E4DD1.60705@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E4DD1.60705@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:13:05PM -0500, Mark Lord wrote:
> On 11-01-24 07:55 PM, Dmitry Torokhov wrote:
> >
> > No, as far as I know we kept ABI intact.
> 
> 
> Okay, I hacked lsinput and input-kbd to ignore the protocol number.
> input-kbd is still broken: it thinks my remote control (Hauppauge)
> has only ten buttons, and won't allow me to remap codes larger than 10.
> 
> I've now hacked around that too, but without determining exactly
> where the interface got broken.
> 
> Ugh.
> 

Where are the sources? I can take a look...

-- 
Dmitry
