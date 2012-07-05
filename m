Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2GENM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:12:56 -0400
Received: from inspiron.ap.columbia.edu ([128.59.145.39]:42695 "EHLO
	inspiron.ap.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab2GENMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:12:54 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 09:12:54 EDT
From: Nikolaus Rath <Nikolaus@rath.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/5] fuse: make maximum read/write request size tunable
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
Mail-Copies-To: never
Date: Thu, 05 Jul 2012 09:04:40 -0400
In-Reply-To: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
	(Mitsuo Hayasaka's message of "Thu, 05 Jul 2012 19:50:17 +0900")
Message-ID: <87vci2gxzr.fsf@inspiron.ap.columbia.edu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> writes:
> Hi,
>
> This patch series make maximum read/write request size tunable in FUSE.
> Currently, it is limited to FUSE_MAX_PAGES_PER_REQ which is equal
> to 32 pages. It is required to change it in order to improve the
> throughput since optimized value depends on various factors such
> as type and version of local filesystems used and HW specs, etc.

This truly is a joyful week for FUSE :-).

Are these patches compatible with the fuse write-back patch series
posted by Pavel a few days ago?


Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C
