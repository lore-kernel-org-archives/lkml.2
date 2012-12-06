Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422652Ab2LFJfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:35:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2LFJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:35:52 -0500
Date: Thu, 6 Dec 2012 10:35:44 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Lekensteyn <lekensteyn@gmail.com>, Heinz Diehl <htd@fritha.org>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121206093544.GA22915@fancy-poultry.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <1498848.rM1KKK5er8@al>
 <20121204210845.GA2092@fritha.org>
 <2102240.hdkK7C4k4g@al>
 <CAKMK7uEaT1H0DUszYqxbp_8WdLWs2quQbSJVqir0eAibYKvN+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEaT1H0DUszYqxbp_8WdLWs2quQbSJVqir0eAibYKvN+A@mail.gmail.com>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:fVqAscXZVp6Aw2Zop+boqTOTR2chb9qmwPeedUFGz/G
 G2cZYx+to3IXX7/O3rMXBGHq1cWo4hINiclo3g5qHNlvL109wo
 JC8OSriFkR2kvvdK4uxsEa3Ptp8zfJ0Jgv7A/lt2Xcr7CJj74o
 IXoBz3KMT0XqRP8nFfEi4QyBS88ZrANoZMc5x9qsHdWq/vWbUB
 BoDWLYKzqOWgoGVghUSq21nLOqU9397UUjxze7WcjgGHwF6bQo
 rKXfcZQmPDA23HcUSVp0IcRdHTJHtk5zw/zyF3CWLrhgZNF2p9
 skRAR8HNFT53OtMujxcaCmJxFcbxdYTsndcOPTIgpDya+u8+rT
 gQ4ud49pjX14X76VHGuTCZcQDMt9WIp6phkiwQbnv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2012, Daniel Vetter wrote:

> Nope, we could only reproduce quickly with rc6 enabled :(

Could reproduce it today this way:

 dd if=/dev/zero of=deleteme bs=1M count=50000

while watching several HD videos on Youtube. Just tried	once, so I'm
not shure if this will work all the way. Will try again now.

My "i915_error_state" is here:

http://www.fritha.org/i915/error-01.tar.bz2

Heinz
