Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1GWWoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 18:44:14 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53130 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1GWWoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 18:44:10 -0400
MIME-Version: 1.0
Date: Sat, 23 Jul 2011 23:44:09 +0100
X-Google-Sender-Auth: 7X8dT9NvcKJinMT5n_DPp-ZXdYk
Message-ID: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
Subject: OLPC power management patches - merge for 3.1?
From: Daniel Drake <dsd@laptop.org>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Many thanks for committing the OLPC power management patches to
linux-tip a few weeks ago.

Even though they were never merged into the master branch of linux-tip
(where I presume linux-next pulls from), they have been included in
linux-next for even longer via Andrew Morton's tree.

Is there any chance you could send them for inclusion in Linux 3.1?
The functionality is working well, but a small fixup is needed for
XO-1.5 (see "[PATCH] x86, olpc-xo15-sci: enable EC wakeup capability"
from 2011-07-09).

Thanks!
Daniel
