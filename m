Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2KVTbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:31:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2KVTbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:31:43 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 0/3] CLK: add more devm_* APIs
Date: Wed, 21 Nov 2012 21:34:39 -0800
Message-Id: <1353562482-12422-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the 2nd version of patchset adding more devm_* APIs to CLK subsystem,
hopefully with all issues addressed.

If this is acceptable then I wonder who will carry the patchset? I can
volunteer :) as I have a couple of pending patches that need this
functionality.

Thanks!

-- 
Dmitry
