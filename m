Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1HXQA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:00:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33004 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1HXQA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:00:26 -0400
MIME-Version: 1.0
In-Reply-To: <201108241641.42676.philipp.reisner@linbit.com>
References: <201108241641.42676.philipp.reisner@linbit.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 24 Aug 2011 12:00:02 -0400
Message-ID: <CAGZ=bq+A1ExZYRnuBBwfAq7Ez37mpBtT1_T91AWcchDBZ3iqPw@mail.gmail.com>
Subject: Re: [GIT PULL] drbd-8.4 for mainline
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 10:41, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> Hi Jens,
>
> First the announcement of drbd-8.4, then the git pull-request text:
>
> We are proud to announce the availability of DRBD-8.4.0.
>
>  The most noticeable change is the support for multiple replicated
>  volumes in a single DRBD connection.
>  Write-ordering is obeyed among all writes in all volumes in a
>  single connection.
>  This feature is really important for users who DRBD for mirroring
>  over longer distances. (Protocol A).
>
> We do not only release DRBD-8.4.0 today:
> The DRBD User's Guide was reviewed and updated to match DRBD-8.4.
>
> I suggest to everybody who considers to upgrade from 8.3 to 8.4
> to have a look at the "Recent changes" appendix of the UG:
> http://www.drbd.org/users-guide/ap-recent-changes.html
>
>  This release brings a new meta-data format. Forward (8.3 -> 8.4)
>  conversion happens complete seamless. Backward conversion
>  is done by a single command (drbdadm apply-al res).
>
>  This release is protocol compatible with all it predecessor.
>  Although, we do not recommend to run it in 8.3 - 8.4 for long
>  time frames. We recommend to use that capability only for the
>  rolling upgrade.
>
>  drbdadm of 8.4 can parse config files of 8.3. We recommend
>  to switch to the new configuration syntax after the upgrade
>  of both nodes. (Use drbdadm dump to learn about the new
>  config syntax)

Hm...

That's a lot of patches (including some protocol changes) that have not
yet been reviewed by other kernel developers.

By officially releasing the kernel and user-space bits and then posting
them to LKML and expecting them to be merged as-is, you are not really
following the linux kernel development process.

Some of the reverts and commit messages make me concerned that your
patch series has bisection issues; are you sure it compiles and runs
after every patch?

I'm obviously not anywhere in the maintenance chain for this code, but
it does look really funny.

Cheers,
Kyle Moffett
