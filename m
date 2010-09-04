Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0IDUmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 16:42:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:54828 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751854Ab0IDUmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 16:42:51 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/IZjQIfLLIzmX0zla/IAWVyoa/5OFcnSXIoF1loA
	wk032LLxTBNKqn
From: Sven Joachim <svenjoac@gmx.de>
To: Hugh Dickins <hughd@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
Date: Sat, 04 Sep 2010 22:42:46 +0200
In-Reply-To: <alpine.LSU.2.00.1009041244440.3044@sister.anvils> (Hugh
	Dickins's message of "Sat, 4 Sep 2010 12:54:38 -0700 (PDT)")
Message-ID: <87vd6ls0jd.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-04 21:54 +0200, Hugh Dickins wrote:

> On Sat, 4 Sep 2010, Pekka Enberg wrote:
>> On Sat,  4 Sep 2010 11:17:14 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> >> This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The commit causes
>> >> wrong screen resolution on some i915 machines such as MacBook which is a
>> >> regression from 2.6.35. The issue has been reported multiple times but no fix
>> >> has emerged:
>> 
>> On Sat, Sep 4, 2010 at 12:21 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > NAK. You can't simply hide one bug by introducing a much bigger one.
>> 
>> Dude, it's a nasty regression from 2.6.35. What exactly are you NAK'ing here?
>> 
>> > As you have an affected machine, find which wait_for_vblank() needs to be
>> > replaced with a msleep(20|50).
>> 
>> The attached patch fixes things here. I'm not a drm developer so I
>> don't know if it makes technical sense.
>
> Many thanks to you, Pekka: I also don't know if it makes technical sense,
> but it solves the same issue for me, so I can at last use 2.6.36-rc on
> this laptop.

Helps for me as well, but I cannot judge whether it makes technical
sense either.  Thanks, Pekka!

Sven
