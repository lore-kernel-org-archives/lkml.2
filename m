Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1HCT6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:58:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37841 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1HCT6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:58:45 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dynamic_debug: add space unconditionally at end of dynamic-prefix
Date: Wed,  3 Aug 2011 13:58:33 -0600
Message-Id: <1312401514-20061-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic_emit_prefix() currently adds a space after line-number,
but not otherwize.  For readability, add space unconditionally.


