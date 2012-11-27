Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2K0PGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:06:55 -0500
Received: from smtp201.dfw.emailsrvr.com ([67.192.241.201]:45974 "EHLO
	smtp201.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab2K0PEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:04:37 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 3/6 v5] cpufreq: tolerate inexact values when collecting stats
Date: Tue, 27 Nov 2012 09:04:31 -0600
Message-Id: <1354028674-23685-4-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is withdrawn due to a need for severe rework.

Changes from v4
	Withdrawn.	
Changes from v3, v2
        None.
Changes from v1
        Implemented a simple round-up algorithm instead of the over/under
method that could cause errors on Intel processors with boost mode.

