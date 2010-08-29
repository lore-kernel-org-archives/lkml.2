Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0H2L3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 07:29:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32803 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0H2L3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 07:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=oytotryy2DVqahRemCMf5x1tXwNmzxRP+fSHnWSQm/Urw3dEanY8r0+ebovodY2rew
         dsWUBq6WVQ8i4PokVZ1LXID7FzlD/NZ8XjlmqqugWNhrU9WU6/XUGlDt5fBsY4RG2hGd
         A3B+NAfZD2ofTcDd3W/XmMC45S7LsGBoafxYE=
MIME-Version: 1.0
In-Reply-To: <1282641126.2259.15.camel@localhost.localdomain>
References: <1282611655.2177.19.camel@localhost.localdomain>
	<8u3s8d$jcftu0@orsmga001.jf.intel.com>
	<1282638912.2191.17.camel@localhost.localdomain>
	<89kc63$hrqmar@fmsmga002.fm.intel.com>
	<1282641126.2259.15.camel@localhost.localdomain>
Date: Sun, 29 Aug 2010 14:29:32 +0300
X-Google-Sender-Auth: pft62hWnj21YFVRRcPRcoiTMm-s
Message-ID: <AANLkTikGRnF8jZLmwA8Ey203K1rMbY1jw6Gb_cAMYmyo@mail.gmail.com>
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
From: Pekka Enberg <penberg@kernel.org>
To: Ivan Bulatovic <combuster@gmx.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, jbarnes@virtuousgeek.org,
        eric@anholt.net, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Tue, Aug 24, 2010 at 12:12 PM, Ivan Bulatovic <combuster@gmx.com> wrote:
> Thanks for the confirmation Pekka. I've managed to change the resolution
> but gdm always starts with 1024x768 and upon login it gets 1280x1024,
> and sometimes the mouse pointer go out of bounds to the right edge of
> the screen but when I maximize windows it sticks to 1280x1024. When I
> start gnome-display-properties that invisible right portion of the
> screen dissapears.

I'm still seeing wrong resolution with my i915 Macbook with latest
Linus' git. Is there a fix in the pipeline or should we start looking
for a commit to revert? As a slab maintainer, I'm supposed to be able
to work with -rc kernels and this particular bug is pretty damn
annoying.

                           Pekka
