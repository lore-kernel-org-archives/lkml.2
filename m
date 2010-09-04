Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0IDWpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 18:45:05 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:54172 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0IDWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 18:45:04 -0400
Date: Sat, 4 Sep 2010 23:44:53 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Hugh Dickins <hughd@google.com>, Pekka Enberg <penberg@kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
Message-ID: <20100904224453.GA31664@sucs.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org> <89k83a$9hv9li@azsmga001.ch.intel.com> <AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com> <alpine.LSU.2.00.1009041244440.3044@sister.anvils> <87vd6ls0jd.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87vd6ls0jd.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 10:42:46PM +0200, Sven Joachim wrote:
> On 2010-09-04 21:54 +0200, Hugh Dickins wrote:
> 
> > On Sat, 4 Sep 2010, Pekka Enberg wrote:
> >> On Sat,  4 Sep 2010 11:17:14 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> >> >> This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The commit causes
> >> >> wrong screen resolution on some i915 machines such as MacBook which is a
> >> >> regression from 2.6.35. The issue has been reported multiple times but no fix
> >> >> has emerged:
> >> 
> >> On Sat, Sep 4, 2010 at 12:21 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> > NAK. You can't simply hide one bug by introducing a much bigger one.
> >> 
> >> Dude, it's a nasty regression from 2.6.35. What exactly are you NAK'ing here?
> >> 
> >> > As you have an affected machine, find which wait_for_vblank() needs to be
> >> > replaced with a msleep(20|50).
> >> 
> >> The attached patch fixes things here. I'm not a drm developer so I
> >> don't know if it makes technical sense.
> >
> > Many thanks to you, Pekka: I also don't know if it makes technical sense,
> > but it solves the same issue for me, so I can at last use 2.6.36-rc on
> > this laptop.
> 
> Helps for me as well, but I cannot judge whether it makes technical
> sense either.  Thanks, Pekka!

Sadly this doesn't help my EeePC 900 with an i915 when it is booted with
a battery inside or after doing a suspend to ram (running
modetest/xrandr in these situations says VGA is connected when there
isn't even a cable attached).

-- 
Sitsofe | http://sucs.org/~sits/
