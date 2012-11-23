Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062Ab2KWJwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:52:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:53296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161019Ab2KWJwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:52:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="246132448"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Henrik Rydberg <rydberg@bitmath.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 3.7-rc6
In-Reply-To: <20121122205352.GA500@polaris.bitmath.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com> <20121120103905.GA3908@polaris.bitmath.org> <CAKMK7uEemJg=h3aY2xfTRaEqC9t5ADgS2-FSasAvdC66zbz1Vw@mail.gmail.com> <20121122111825.GA7188@polaris.bitmath.org> <CAKMK7uFr8jHALagnzJp26Sn-WMuj4VcMF0e+q0GKgyRbW0h-wg@mail.gmail.com> <20121122182325.GA777@polaris.bitmath.org> <CAKMK7uH1=vA7YCh9eZSyW=ewF3kYkdgT45LhYqnigPg0whe5aA@mail.gmail.com> <20121122205352.GA500@polaris.bitmath.org>
User-Agent: Notmuch/0.14+81~gb5c1e13 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 23 Nov 2012 11:53:16 +0200
Message-ID: <877gpchchf.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Yeah, the utter lack of a vbt fits very nicely, thanks for checking,
>> I've merged the patch into drm-intel-fixes and will forward it for
>> inclusion into 3.7 rsn.
>
> Great, thanks. One thing about that patch: if we would ever encounter
> a non-zero edp.bpp < 3, display_bpc would not be clamped. I suppose
> monochrome screens went out of fashion twenty years ago, but who
> knows...

ATM, edp.bpp is known to be 18, 24, or 30. It's mapped from a two-bit
value in the VBT.

Glad to hear the patch works for you.

BR,
Jani.
