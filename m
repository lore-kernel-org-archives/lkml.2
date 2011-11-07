Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab1KGMto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:49:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab1KGMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:49:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111107154936.7c60be38@natsu>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net> <20111107154936.7c60be38@natsu>
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Mon, 7 Nov 2011 13:49:21 +0100
Message-ID: <CAK-xaQbT+hrO-DOoiTDrU_4KfQuc+xvc4D_F0JFnWNHdGOTkQA@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
To: Roman Mamedov <rm@romanrm.ru>
Cc: Arne Jansen <sensille@gmx.net>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/7 Roman Mamedov <rm@romanrm.ru>:
> If so, shouldn't there also be a corresponding dmesg warning about "Unable to allocate....", which would confirm or rule this out?
> So before following the "did you try turning it off and on again" advice (and throwing away useful debug info), I'd suggest checking/saving dmesg first.

Hi Roman,
   and thanks a lot for your reply.
   I did check dmesg and /var/log also, but I didn't find complain about it.

   So, I tried with a loopback device and it works well.
   Maybe the problem is about my device stack?
   Bottom up my home is on a: md + luks + lvm + md + btrfs.

Thanks a lot for your time,
Andrea
