Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0GGS5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:57:07 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:34781 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0GGS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:57:05 -0400
To: Ben Guthro <ben@guthro.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915: Dell E6410 Ironlake LVDS detection
References: <AANLkTim362_xv5FAyFSpdnAFUlILliEoGBW8_oZ4QVj1@mail.gmail.com>
	<87bpb1fxwg.fsf@old-tantale.fifi.org>
	<AANLkTinm1ZXybaAgCUGGPkK_YKaGmO9k2mduoy9ThnQ3@mail.gmail.com>
	<877hlpfwlh.fsf@old-tantale.fifi.org>
	<AANLkTim6IiHbd6tN6bfS2kppRPaIzoGLC6nAl5IF3dOj@mail.gmail.com>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 07 Jul 2010 11:56:51 -0700
In-Reply-To: <AANLkTim6IiHbd6tN6bfS2kppRPaIzoGLC6nAl5IF3dOj@mail.gmail.com>
Message-ID: <87bpaj3yto.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Guthro <ben@guthro.net> writes:

> On Wed, Jun 23, 2010 at 2:11 PM, Philippe Troin <phil@fifi.org> wrote:
> > Ben Guthro <ben@guthro.net> writes:
> >
> >> On Wed, Jun 23, 2010 at 1:42 PM, Philippe Troin <phil@fifi.org> wrote:
> >> > I am seeing similar problems with an HP Elitebook 2540p.
> >> >
> >> > 2.6.32 works for me.
> >> > 2.6.33.5 does not.
> >>
> >> I have tried ubuntu mainline builds of:
> >>
> >> 2.6.32.21
> >> 2.6.32.22
> >> 2.6.34-rc3
> >> 2.6.35-rc1
> >> 2.6.34-drm-intel-next
> >>
> >> None have worked yet...
> >
> > Tried a vanilla kernel?
> 
> Yes, both mainline, and the drm-intel branch. Both boot to the black screen,

2.6.35-rc4 works for me.

I am still experiencing issues with:

 - hotplugging an external monitor (screen goes black)

 - suspend (resume works but screen is black upon resume).

Phil.
