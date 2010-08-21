Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab0HUQth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 12:49:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63705 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0HUQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 12:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mnBk5w0lhT3OhDelV1JvpQ2TvlKgpfGIhTBp38ipHjTDtsctTGUwdPqAwpRvdtBpv6
         aRGmJn+3JZGWlzW8ErDJy+27vfVWeAm6rcJvgTjzfbGoxc1Hq6Fk8e701erP3ZwOPu3O
         2TmzQL2f+ZWdyAUbd0gSua74D9X7Xnb+LA5jg=
Date: Sat, 21 Aug 2010 09:49:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Daniel Mack <daniel@caiaq.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: mousedev - fix regression of inverting axes
Message-ID: <20100821164929.GA13677@core.coreip.homeip.net>
References: <20100820223316.4f6ac734@neptune.home>
 <20100821135002.GA3357@lovely.krouter>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100821135002.GA3357@lovely.krouter>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 03:50:03PM +0200, Christoph Fritz wrote:
> On Fri, Aug 20, 2010 at 10:33:16PM +0200, Bruno Prémont wrote:
> > Somewhere between 2.6.35 and Linus's tree as of this writing gpm
> > started moving its cursor to the opposite direction of mouse movement.
> > 
> > e.g. moving mouse up causes cursor to move down, moving mouse left
> >      causes cursor to go right
> > 
> > Under 2.6.35 the cursor moved into the same direction as the mouse.
> > 
> > Note, mouse is synaptics touchpad (Acer TravelMate660):
> >   Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006/0x0
> > 
> > 
> > When I get around to it I will try to get more precise information as
> > to when this regression got introduced, eventually bisecting.
> > 
> > Bruno
> 
> Thanks Bruno,
>  I successfully tested the patch below with gpm.
> 
> ---
> Introduced by 987a6c0298260b7aa40702b349282554d6180e4b a swap in max/min
> calculation gets fixed by this patch.
> 
> Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>

Applied, thanks Christoph.

-- 
Dmitry
