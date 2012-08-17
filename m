Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab2HQChb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:37:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64797 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2HQCh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:37:27 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 0/2] dyndbg: trivial fixes
Date: Thu, 16 Aug 2012 20:37:21 -0600
Message-Id: <1345171043-14859-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.1.487.ga3935e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 trivial patches here, suitable for 3.6:
- fix spelling error in comment s/control/control
- add write size attempted to log warning issued for E2BIG error

