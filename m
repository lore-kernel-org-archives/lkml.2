Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2IUKGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:06:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48957 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2IUKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:06:43 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com
Subject: [PATCH v2 0/4] mfd: support dt on 88pm860x
Date: Fri, 21 Sep 2012 18:06:50 +0800
Message-Id: <1348222014-15927-1-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
v2:
1. Resolve merge conflict since other patches also update 88pm860x-core.c
2. Add document of DT support

v1:
1. Updates the patch of max8925 of building issue.
2. Include Jett's PREG regulator patch.
3. Support DT in 88pm860x.

