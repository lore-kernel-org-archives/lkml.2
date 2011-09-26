Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1IZKP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:15:26 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:60433
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab1IZKPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:15:24 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p8QAFAQF012787
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drm/i915: problems after closing/opening lid
In-Reply-To: <yunk48wkz5t.fsf@aiko.keithp.com> (Keith Packard's message of
	"Sun, 25 Sep 2011 15:58:06 -0700")
References: <gibou8tkk4.fsf@mx10.gouders.net>
	<yunk48wkz5t.fsf@aiko.keithp.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Mon, 26 Sep 2011 12:15:09 +0200
Message-ID: <gioby73902.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Mon, 26 Sep 2011 12:15:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard <keithp@keithp.com> writes:

> On Sun, 25 Sep 2011 22:48:43 +0200, Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>
>> I bisected this to commit 9aa73a51c91cb0d0af4caaa9823969c1a1179a12.
>> I played with the params that were inverted in that commit and if I
>> change both or one of them via command line, there is no problem, the
>> problem only occurs if both of them have the new values.
>
> You should be good if you run the drm-intel-fixes branch of my repo at
>
>         git://people.freedesktop.org/~keithp/linux
>
> That disables FBC on your Ironlake GPU.

Thanks, Keith, with that branch the problem has gone.

Dirk
