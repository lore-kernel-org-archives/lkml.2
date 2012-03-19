Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030305Ab2CSGpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:45:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34634 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825Ab2CSGpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <C141162D-9164-43D3-9A1F-93156DC7409B@jonmasters.org>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
	<CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
	<87obshxt4w.fsf@xmission.com>
	<CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
	<87zkc1w6wp.fsf@xmission.com>
	<CAKaWdxa8yJJhnPj1th6GdYvn9+Lu7GUV1e=960gMQOdc8W47dQ@mail.gmail.com>
	<CAKaWdxaaKMiwnhP7R786mqHTPs+o=izerZDbUgPBaxyU+XL-2g@mail.gmail.com>
	<C141162D-9164-43D3-9A1F-93156DC7409B@jonmasters.org>
Date: Mon, 19 Mar 2012 19:45:10 +1300
Message-ID: <CAKaWdxafKU6+s-1-5jqw=JzvUE7ntYUh=T3JOooDWVoiHgq9NA@mail.gmail.com>
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
From: Keith Chew <keith.chew@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon

> I've just been reviewing LKML for the past month…was there ever any followup?
> Perhaps it's worth discussing a patch to change the below delay?
>

I was about to prepare a patch for this change last Friday, but the
system hanged on Saturday, after a few weeks of smooth reboots. The
other unit with reboot=p (as Eric suggested to be the most reliable
way of rebooting) is still going without any issues, so maybe that is
the best workaround for now.

I have now put the first unit in reboot=p, and will keep monitoring
them. I am open to any other suggestions if anyone has any tweaks they
think will help with the KBD reboot.

Regards
Keith
