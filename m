Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab0GTXfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:35:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341Ab0GTXfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100720233238.GS32635@dastard>
References: <20100720004630.GH23223@dastard>
	<20100720233238.GS32635@dastard>
Date: Tue, 20 Jul 2010 16:35:14 -0700
Message-ID: <AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
Subject: Re: [GIT PULL] Shrinker fixes for XFS for 2.6.36-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Ijust rebased the series - the shrinker context patch did not pickup
> the new shrinker in the TTM DRM code for radeon. New pull-request output
> below.

Not good. I already pulled the earlier version yesterday. So a rebased
series is useless.

                          Linus
