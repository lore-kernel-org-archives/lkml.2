Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab1LGVTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:19:25 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:42488 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab1LGVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:19:24 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 0/4] V2, Move stuff out of xenfs
Date: Wed,  7 Dec 2011 22:13:12 +0100
Message-Id: <1323292396-19523-1-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In <20100605162947.GA31336@wavehammer.waldi.eu.org> I started the
discussion about xenfs and the usage of it. This is the second try to
move stuff over into normal device drivers.

Changes:
- Remove guest_capabilities stuff. It is only used to detect if the init
  scripts should start anything.
- Fix error values.

Bastian

