Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2LNQTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:19:50 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64189 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2LNQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org
Subject: [PATCH 00/21] gpio: ab8500: Bring AB8500 back to life
Date: Fri, 14 Dec 2012 16:19:18 +0000
Message-Id: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ab8500 GPIO driver is currently 'BROKEN', due to a lack of
updates and recent frame-work adoption. This patch-set aims to
bring the driver back to life so we may make use of it again.

This first stage is to bring it into line with ST-Ericsson's
internal track, which has been keeping up-to-date. After these
patches have been accepted I will then overhaul the driver to
use the most recent APIs and frame-works, such as pinctrl and
Device Tree.

Please give these patches an easy ride. I know they're not
perfect, but they do provide a great base on with I can form
the overhaul. Thanks for your understanding.

