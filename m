Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071Ab2B1Kl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:41:56 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:59640 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964941Ab2B1Klx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:41:53 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Turner <pjt@google.com>
Subject: sched per task ARM fix
Date: Wed, 29 Feb 2012 10:37:37 +0000
Message-Id: <1330511859-22032-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
References: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Paul,

The patch series were failing to build for ARM, and with these small
fixes they do, and they appear to work, at least on panda where I tested them.
It also didn't build when CGROUPs where not configured so there's that as well.

Regards

-- Pantelis
