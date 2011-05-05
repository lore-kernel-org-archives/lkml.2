Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1EERmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:42:21 -0400
Received: from mail.tpi.com ([70.99.223.143]:4017 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1EERmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:42:20 -0400
From: tim.gardner@canonical.com
To: linux-fbdev@vger.kernel.org
Cc: lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] fbcon -- fix race between open and removal of framebuffers
Date: Thu,  5 May 2011 11:41:46 -0600
Message-Id: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm sending this out for Andy since he is a bit busy this week and has been
gone for the past several weeks. Its been on our todo list to get this
upstreamed, but release pressures have intervened. Mea culpa. I've also had
a couple of requests recently which have served to remind me to get off my butt.

https://lists.ubuntu.com/archives/kernel-team/2011-May/015544.html

rtg
