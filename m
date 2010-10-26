Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab0JZUks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:40:48 -0400
Received: from bar.sig21.net ([80.81.252.164]:59537 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab0JZUkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:40:47 -0400
Date: Tue, 26 Oct 2010 22:40:43 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Compat-wireless release for 2010-10-25 is baked
Message-ID: <20101026204043.GA2608@sig21.net>
References: <20101025190358.AEC6840F97@repository3.orbit-lab.org>
 <20101026123552.GA4604@sig21.net>
 <AANLkTimzUKj=C9PxGs1PkQy_KWu0PGKd1zv_m-ZpWaEm@mail.gmail.com>
 <20101026184123.GA1616@sig21.net>
 <AANLkTimHpyJho6AheQc6zos7Pmr-ECjvaL83mYDC19Yd@mail.gmail.com>
 <AANLkTi=TPCXXki3jrrFA1HiauDp0rZVtMK9fK4z8B_kv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=TPCXXki3jrrFA1HiauDp0rZVtMK9fK4z8B_kv@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.739,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 26, 2010 at 09:48:12PM +0200, Ivo Van Doorn wrote:
> For rt2x00 development you can choose between rt2x00.git and
> wireless-testing.git,
> the trees are usually not that far apart, since smaller patches are pushed quite
> quickly upstream. (Also rt2x00.git is rebased frequently, while
> wireless-testing.git rarely
> is rebased)

Thanks for clarification.  I guess I'll start with wireless-testing,
that sounds a bit more newbie-friendly.  I just want to avoid
searching or reporting bugs which are already fixed, but your description
sounds like changes are pushed from rt2x00.git to wireless-testing.git
maybe weekly.  I was afraid patches would be pushed to wireless-testing.git
only when it's time to get ready for the next merge window.


Thanks,
Johannes
