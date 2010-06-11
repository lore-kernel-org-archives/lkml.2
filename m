Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0FKPJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:09:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62494 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0FKPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:09:17 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] AFFS clean-ups
Date: Fri, 11 Jun 2010 18:05:18 +0300
Message-Id: <1276268720-7398-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
X-OriginalArrivalTime: 11 Jun 2010 15:09:12.0327 (UTC) FILETIME=[0CA84170:01CB0978]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

you requested me to clean up 'sb->s_dirt' users, but did not respond
to my last "sync_supers" optimizations patch series:
http://marc.info/?l=linux-fsdevel&m=127583599911620&w=2

Probably the patch series was too large, so I decided to submit you
few patches at a time. Here are AFFS clean-up patches. They lessen
the amount of places where it refers 'sb->s_dirt', and fix few issues.

The patches were tested - I mounted AFFS, did some simple operations,
added prints to write super and saw that it is still synchronized.

Please, take a look and add to your tree if they are fine. I'll then
send you some more patches.

Artem.
