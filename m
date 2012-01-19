Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2ASQYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:24:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41355 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2ASQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:24:20 -0500
MIME-Version: 1.0
In-Reply-To: <4F182BED.3090009@gmail.com>
References: <4F182BED.3090009@gmail.com>
Date: Thu, 19 Jan 2012 10:24:19 -0600
Message-ID: <CAKcLGm9kVOw6D8kPECfhfohH4pAT=09qws7-jRsh1TZJTyh1_A@mail.gmail.com>
Subject: Re: [BUG - btrfs] kernel oops in extent_range_uptodate
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 8:42 AM, Vincent Vanackere
<vincent.vanackere@gmail.com> wrote:
> Hi,
>
> With the most current git kernel (90a4c0f51e8e44111a926be6f4c87af3938a79c3)
> I'm still getting the same reproducible kernel panic when trying to read a
> particular file stored on a btrfs filesystem (as seen in the log there are
> indeed disk media errors on this disk).
> I'd like the "software" part of this to be fixed - btrfs should definitely
> not oops even in case of media error - before sending the disk to RMA. Is
> there anything I can do to make progress on this ?
>

Is this kernel compiled with "Compile the kernel with debug info" (in
the "Kernel hacking  --->" configuration section)?

It would be nice to have the specific line of code passing the NULL pointer.
