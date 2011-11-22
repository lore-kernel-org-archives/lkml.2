Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab1KVBlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:41:13 -0500
Received: from natasha.panasas.com ([67.152.220.90]:47587 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1KVBlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:41:12 -0500
Message-ID: <4ECAFDAD.5040801@panasas.com>
Date: Mon, 21 Nov 2011 17:41:01 -0800
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com> <4EBAB5F7.80000@xenotime.net> <CA+5PVA6tBx4i1XZ+AF=uaOsjYCshG9CzXHWjnJcsJ=z1qw1F4A@mail.gmail.com>
In-Reply-To: <CA+5PVA6tBx4i1XZ+AF=uaOsjYCshG9CzXHWjnJcsJ=z1qw1F4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 09:28 AM, Josh Boyer wrote:
> 
> Fedora uses those.  We also used the -gitX snapshot patches when they
> were generated, but now we do that by hand (which we also did for the
> -rcX patches while kernel.org was down.)
> 
> josh

My god that totally-brain-dead Fedora Kernel rpm generation.

RANT a head should be skipped!!

I wish there was a strait forward way to point to a Kernel
git tree HEAD and say "make rpm", which is simply the tar
of the "make modules_install" and the "make install" output
+ a simple script to manipulate grub.conf

Not today's Fedora-Kernel git tree which is not a Linux
git tree at all but those patches above + stable.
Any simple tree moments needs to involve black patch magic
and fear of hell. (Don't try this at home)

Actually the "grub-selector" should have been it's own
rpm. And each Kernel can/should be it's own independent
(none conflicting, right) package. I know, I know, it tries
to be that, but it is not. For example I want a low-latency
rt Kernel as a side choice for any Kernel, and so on...

Throw away that monstrous  Fedora-Kernel-tree. There is
only one Kernel tree it is called Linux. You can do your
own back/forward port branches based on stable to your
heart's content with out inventing a new totally different
patches tree.

Someone stop me. There is no end to the RANT I can
generate about Fedora Kernel release

Boaz
