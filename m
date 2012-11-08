Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2KHNsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:48:50 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:52642 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751193Ab2KHNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:48:49 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/5]  Remove all the reference to feature-removal-schedule.
Date: Thu,  8 Nov 2012 21:46:42 +0800
Message-Id: <1352382402-2706-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 122.224.222.226 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there are still some reference to this file. So remove all of them.

Thanks
Tao
