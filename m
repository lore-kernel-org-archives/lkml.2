Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2F3VPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 17:15:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43262 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751800Ab2F3VPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 17:15:03 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19f/0pyjrJfY+RlnyuWwnw32N06sB4AHmIVW0QXw9
	H5lX+8Rkw1ieuJ
From: Sven Joachim <svenjoac@gmx.de>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, dri-devel@lists.freedesktop.org,
        Adam Jackson <ajax@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Bogus video resolution in Linux 3.5-rc4
References: <874npzebev.fsf@turtle.gmx.de> <s5ha9zr8k2f.wl%tiwai@suse.de>
	<87obo7jnmn.fsf@turtle.gmx.de> <s5ha9zr2o1a.wl%tiwai@suse.de>
	<87r4t3w59r.fsf@turtle.gmx.de> <s5hsjdi1qtv.wl%tiwai@suse.de>
	<4FEF499E.1090107@gmail.com>
Date: Sat, 30 Jun 2012 23:14:57 +0200
In-Reply-To: <4FEF499E.1090107@gmail.com> (Calvin Owens's message of "Sat, 30
	Jun 2012 13:46:54 -0500")
Message-ID: <878vf4o626.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-30 20:46 +0200, Calvin Owens wrote:

> I had the exact same problem as Sven, bisected to cb21aafe121b1c3ad4c77cc5c22320163f16ba42.
> Takashi's patch (supra) fixes the issue for me.

For me as well.  Sorry for the slightly belated reply, was busy with
other things in the last few days.

Thanks,
       Sven
