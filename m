Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047Ab2JYSHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:07:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60320 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab2JYSHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:07:04 -0400
Date: Thu, 25 Oct 2012 20:06:54 +0200
From: Heinz Diehl <htd@fritha.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Cc: Martin Peres <martin.peres@labri.fr>, Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lekensteyn <lekensteyn@gmail.com>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121025180654.GA28920@fritha.org>
References: <1724445.dN2yMEzN6d@localhost>
 <20121020092647.GA3186@fancy-poultry.org>
 <50827174.7070109@labri.fr>
 <2097113.JL2tUTAZjM@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2097113.JL2tUTAZjM@localhost>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:UKhESbsAWgd/7Q4tJClbNw45G3E+dkb0ehzU5bY3hsS
 0C7ZrRqUAy1x+d5bynSNwWs9P3icQlqu7wdzE3UpTCLNy/gnSi
 RE8zLIW6+ImJoSKghmfZSfXaGyLTxPsuEAdTZZPySSmIdsCMah
 NfZpsSnlC3H8XdnOPn36c0nJUGCrtyt7vfrykb/7SCcvA0IV8P
 qTAz8p+5rrTsday99aXB1Vmmp8sETEzspHlC5c0UvjQSaUm55t
 rBGTmH8fVbCzX9ALCUfDrmAQvghxK7CMk7edsl4jjXTwmO46bZ
 AifmNnp9ejDwCPugoYuXPhBqVoYApL+ve55n4zuREJqw3asV6F
 7KrJ3XArtlswwCbvRyFQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.10.2012, Paweł Sikora wrote: 

> what is the reason of loading nouveau driver for laptops 
> with nvidia optimus and enabling vga switcheroo
> which doesn't work in such (optimus) cases.

You can safely compile a kernel without nouveau, your Nvidia 
card will not be used at all since neither Linux nor the 
proprietary nvidia driver does support optimus at this time
(and frankly, I won't buy any further machines with opticrap).
So having nouveau compiled and loaded seems like a waste of ressources
in this case.

For me it's important to have nouveau working, because I try/use
Bumblebee and optirun: 

http://bumblebee-project.org/
https://fedoraproject.org/wiki/Bumblebee

