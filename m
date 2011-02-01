Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1BAJF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:05:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45063 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1BAJFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=QY6H5FqCoP0morJ6s0CWkweAmasS0l94NkkZjp0+WYYTq3ySvD2o63aO2jyIGgwoWU
         FF5QeftgW+bwQ4w+DFO0AoAKEsvuabkl5jDUB4V2ai6F7IxtyH9Jpct3n1lX4MzkRJQQ
         XRl+eNwTS2Wiu0l6l1oJRq+jPP6VygtkJK4+s=
MIME-Version: 1.0
Date: Tue, 1 Feb 2011 18:05:23 +0900
X-Google-Sender-Auth: ieBUDvnBmihlfv12wd-m7puT4kU
Message-ID: <AANLkTikYw73nixqMtNSDzus2M5RCN2Zy4PzfbPAxtTBC@mail.gmail.com>
Subject: Why one of the 2 patches to fix "autogroup" sched problem on UP
 machines is missing in -rc3?
From: Kazuhisa Ichikawa <ki@epsilou.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yong,

Now 2.6.38-rc3 is out, and I think one of the 2 patches you wrote to
fix "autogroup" sched problem on UP machines is missing there.

More precisely, your first patch for kernel/sched.c (titled: sched:
tg->se->load should be initialised to tg->shares) is missing, while
the second one for kernel/sched_fair.c (titled: sched: Fix poor
interactivity on UP systems due to group scheduler nice tune bug) is
in -rc3.

So what happened to the first patch? Was it superseded and made
obsolete by the second patch?

# Sorry for not replying to your original post. I'm not subscribing to
linux kernel mailing list.

Regards,

- Kazuhisa
