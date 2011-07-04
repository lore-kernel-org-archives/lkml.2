Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1GDOHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:07:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab1GDOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:07:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Date: Mon, 4 Jul 2011 16:07:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Ryan Mallon <rmallon@gmail.com>, Bill Gatliff <bgat@billgatliff.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <201106301441.24493.arnd@arndb.de> <4E11994B.7070103@gmail.com> <20110704124318.GI6069@pengutronix.de>
In-Reply-To: <20110704124318.GI6069@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041607.10265.arnd@arndb.de>
X-Provags-ID: V02:K0:EJoJEz18ZD66AsE4F6gs4aIf1cd9BUdtveMVvvk/44D
 k/H92MS4FNIchtkhz2mXYgInulcnGgG8NqJtZlv3SznsVzEV06
 1KR9DjpKCEGKhzeBs7j6lXCKrvtaz5cso+18GE3agXkutdsnIA
 voZoIMjOsUOb75YToJ4lhCg4+dJcaVUekLfPh7OeZAeTFVJwrp
 Iw3T7kj1MzD93hgw7Z/1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 July 2011, Sascha Hauer wrote:
> On Mon, Jul 04, 2011 at 08:43:23PM +1000, Ryan Mallon wrote:
>
> > The fine-grained control api could be added now. pwm_config could be
> > left as is for the time being (the new api could be a wrapper around it
> > to start with). Polarity control and interrupt handling apis could also
> > be defined without affecting the drivers which don't need to implement
> > them. Multiple channels and the sleeping/non-sleeping api are the more
> > difficult ones, but at least having some sort of indication about how
> > these plan to be solved would be useful.
> 
> Again, why should we add these *now*? It only raises the chance that
> there's more discussion.

My impression is that there are a lot of things that could easily be
done to improve the state of PWM drivers, but I don't care about the
order in which they are done. My main issue is the lack of a subsystem
core driver, which both you and Bill have patches for. It's clear that
other people have other issues and want to see their problems addressed
first.

I also think that the pwm code is simple enough that we don't have
to worry too much about the order that things are done in. Any patch
that is making the code better should just get in and not have to
wait for something else to be completed first.

What we do need now is a maintainer that can coordinate the patches
and merge the ones that have been agreed on. Or multiple maintainers.

	Arnd
