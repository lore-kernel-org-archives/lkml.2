Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2KSTaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:30:10 -0500
Received: from mailhost-z4-m4.nerim-networks.com ([78.40.49.247]:15980 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754438Ab2KSTaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:30:08 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 14:30:08 EST
Date: Mon, 19 Nov 2012 20:22:09 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Olof Johansson <olofj@chromium.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, Aaron Durbin <adurbin@chromium.org>,
        stable@vger.kernel.org, Puneet Kumar <puneetster@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5] mm: Fix calculation of dirtyable memory
Message-ID: <20121119192209.GA3718@brouette>
References: <20121119134001.GA2799@cmpxchg.org>
 <1353350518-32623-1-git-send-email-sonnyrao@chromium.org>
 <CAPz6YkXazpiJgKHnQx=dpr4XOCo8J_PBeffDG7mfPk7rPy2a-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPz6YkXazpiJgKHnQx=dpr4XOCo8J_PBeffDG7mfPk7rPy2a-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sonny Rao <sonnyrao@chromium.org> [2012-11-19 10:44]:
> Damien, thanks for testing and finding that bug.  If you could, please
> give this version a try, thanks.

Tried it for a few hours (as soon as the min/max problem was suggested
on the list) and the previous problems disappeared.

-- 
Damien
