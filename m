Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0GYL5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 07:57:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38463 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0GYL5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 07:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VFAJKgAC+UkzNivGsyZxVR+b0r84Dwbqbx3lZrUjibI8mahXW+YJ+JcIfqGbQXuyYN
         xEuxW2SgVir1YCeyAKNv4cJNszIBIS1w2GEvUHiUurubPw/JvKGAPhhOMGbNi4m6a6iA
         J7oOoS44l29C4pzwkjmlP+AK+AkQQE1V2HVws=
Date: Sun, 25 Jul 2010 13:54:24 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nouveau@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] [PATCH v2] vga16fb: refuse to load in face of other
 driver controlling primary card
Message-ID: <20100725115424.GA2837@joi.lan>
References: <20100720191923.GA11056@joi.lan>
 <20100722172039.e935c67d.akpm@linux-foundation.org>
 <20100723131034.GA6618@joi.lan>
 <AANLkTimQZ6_+o=3pGa6hGbeFU99RMPFRmO+ndMZDHZMS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimQZ6_+o=3pGa6hGbeFU99RMPFRmO+ndMZDHZMS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 06:42:48PM +1000, Dave Airlie wrote:
> On Fri, Jul 23, 2010 at 11:10 PM, Marcin Slusarz
> <marcin.slusarz@gmail.com> wrote:
> > On Thu, Jul 22, 2010 at 05:20:39PM -0700, Andrew Morton wrote:
> >> On Tue, 20 Jul 2010 21:19:23 +0200
> >> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> >>
> >> > We don't want vga16fb to mess with hardware initialized by other driver.
> >> > Detect it and refuse to load.
> >> > It fixes nouveau interrupt storm on some machines.
> 
> Can't we keep this all inside vga16fb? 

That's what v1 did (*), but Andrew didn't like it.

> just have it walk PCI tree
> looking for a primary VGA card, and if it has a driver bound, just
> refuse to bind.
> 
> Dave.

(*) http://lkml.org/lkml/2010/7/20/244

