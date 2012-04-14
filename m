Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2DNTeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:34:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46363 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2DNTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:34:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120414155733.GF19802@1wt.eu>
References: <20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120414094137.54a7f213@stein>
	<CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
	<20120414155733.GF19802@1wt.eu>
Date: Sat, 14 Apr 2012 22:33:59 +0300
Message-ID: <CAMP44s0omtoT=4zN=sOQYGLwfWGiw4w4iAj+OS+gGOsNMatq9g@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 6:57 PM, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Apr 14, 2012 at 06:29:54PM +0300, Felipe Contreras wrote:
>> So, the hypothetical patch that was dropped in the stable review queue
>> yesterday has to be fixed in mainline too, just like the hypothetical
>> patch that made it to stable and was found problematic today has to be
>> fixed in mainline.
>
> Patches are not always dropped from the stable queue if we know they're
> causing issues, sometimes they're left pending in the queue. This is how
> Greg is able to ping developers from time to time.

That's news to me, but the important point remains; they don't make it
into the stable release, correct? Yet, we still expect them to be
fixed in mainline, correct?

>> Again, what makes a released patch undroppable?
>
> Being applied, in other words, having a commit ID in the branch.

Seriously? That's your reason?

Hey, thousands of users out there; the reason why we pushed a patch
that is known to be broken in v3.3.x is because it already has a
commit ID.

If that's your idea of a good reason then I don't see any point in
discussing with you any more. No offense intended.

Cheers.

-- 
Felipe Contreras
