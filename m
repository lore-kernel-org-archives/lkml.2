Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2FMKYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:24:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55328 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2FMKYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:24:13 -0400
Date: Wed, 13 Jun 2012 11:27:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
Message-ID: <20120613112752.787a3b2e@pyramind.ukuu.org.uk>
In-Reply-To: <CAH9NwWdT7RhDfgLiF15m2yAExmb-Gsq1TCOGbvJEQ9Lzd3DH8A@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
	<CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
	<CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
	<CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
	<CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
	<20120612132736.642a4a5a@pyramind.ukuu.org.uk>
	<CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
	<20120612170412.359967ec@pyramind.ukuu.org.uk>
	<CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
	<CAH9NwWdT7RhDfgLiF15m2yAExmb-Gsq1TCOGbvJEQ9Lzd3DH8A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here are some more informations. There seems to be a scaling problem.
> If i compare gma500 and the vesa framebuffer driver I see that gma500 shows
> the desktop "scaled" up --> not the whole desktop is on the screen. It
> gets better
> if i remove the video="..." parameter from kernel cmdline, but it
> still is too big for
> the screen.

"scaled up" meaning what - pixel sizes. I don't really understand what
you are trying to describe ?

What size is the desktop reported at, what created the "desktop" ?

