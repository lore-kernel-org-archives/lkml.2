Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2JTKmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:42:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2JTKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:42:48 -0400
Date: Sat, 20 Oct 2012 12:42:38 +0200
From: Heinz Diehl <htd@fritha.org>
To: Martin Peres <martin.peres@labri.fr>
Cc: Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121020104238.GA1539@fritha.org>
References: <1724445.dN2yMEzN6d@localhost>
 <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
 <20121020092647.GA3186@fancy-poultry.org>
 <50827174.7070109@labri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50827174.7070109@labri.fr>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:gD/mOxHQCue2jYv9W9Cbi6RxbdL7CNDZ+hk0Rx0zFyN
 OEmC0E8qNiBBSjAG2MYs0BvyCngdbOemxmPDCqibhVhS0m84DN
 BL8ZoX13y4JkG5mvz5enZe567SqGOkNGt7Jk4eq0q0f7z4h7fp
 xHuSEmrmDRto5vs5cFyRnRPD2qEKodY/ACmjtvrBPk3PZ1Qivp
 Re1Y/ZoEBa+ic9avpbqhblrFa6E7rGY3Wn4P0bH67F+5xpDAeu
 6w1MEaYHlB1n51hHtkYaoZdWq5SDu032YBZhLpkwnVJTlGdnVL
 TPKeumqZb0kkxuajLMB0i1XL1M1rakDBd//EDEZungbht0vTu+
 pF2/ktx9bmtRPEHDaspU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.2012, Martin Peres wrote: 

> Can you test the attached patch too ? I rebased the previous one I sent on
> top on 3.7-rc1 as I accidentally used an older version.

Yes, of course.

Tried it. Unfortunately, the crash remains the same as reported.

