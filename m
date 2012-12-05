Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2LEGfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:35:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2LEGfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:35:33 -0500
Date: Wed, 5 Dec 2012 07:35:28 +0100
From: Heinz Diehl <htd@fritha.org>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121205063528.GA20434@fritha.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <1498848.rM1KKK5er8@al>
 <20121204210845.GA2092@fritha.org>
 <2102240.hdkK7C4k4g@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2102240.hdkK7C4k4g@al>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:8fHQtMKXnByhdrzPQG2VDFhApLWOU7tTtDOzSlQ/yWZ
 VBxXAWL6NHG0UxegWXg2YCCpi8aEKO4TTiJaKcol5BPTzeHA1Q
 wxecYAJ6hkbIi3rMD7NJtv2NamZb6/6IqpY3szgHobgEgVmy7U
 xY3bedpzhhBc9DJ5ZtxB0Yf50RQR37xlNid1gyz9KDmOwmDJPM
 VYSBhl7W3fmpmN56qHggilDVAI0ttXW+3JPqU2Db5T+UN6ugSJ
 ASkx1YnQR46SI/GSIubcQpv0v6f5nljpUTPteX4zTlAWNpBlr2
 oBWFxbXW2f0fOqooh2kd0F54/0Q4oWXzzL7OU2pGNsr01sEbPE
 EQ8nm2V0MBZZcvOHMAzc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2012, Lekensteyn wrote:

> > I have now i915.i915_enable_rc6=0 in grub.cfg and disabled the XFCE
> > compositor. Now I'm trying to hit the bug again...

> Do you have a reliable reproduce method? As you can see in the linked bug it
> was caused by relatively low memory pressure combined with high I/O (caching?
> delays? Who knows).

No, unfortunately not. I will do my very best to find out how to
trigger it. For	  now, I'm trying with a script which produces
max. I/O. Will also try by replaying a lot of high resolution videos and
similar.

> It is unlikely that Optimus has anything to do with this.

Ok.

Heinz
