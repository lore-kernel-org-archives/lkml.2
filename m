Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049Ab2B2AgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:36:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2B2AgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:36:18 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] Input: atkbd - Add force relese key quirk for HP ProBook
Date: Tue, 28 Feb 2012 18:36:09 -0600
Message-Id: <1330475770-4153-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider this patch for HP ProBooks, which do not send a key
release for brightness keys, as a result, the brightness keys are not
typematic. This quirk fixes that issue.

This patch was tested by me and found to work on HP ProBooks.

