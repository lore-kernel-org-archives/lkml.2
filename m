Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571Ab2J3VEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:04:13 -0400
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:58634 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934543Ab2J3VEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:04:10 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Tue, 30 Oct 2012 16:04:10 -0500
Message-Id: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds cpufreq support for the Calxeda ECX-1000 (highbank)
SoCs. The driver is based on the cpufreq-cpu0 driver. Because of the 
unique way that highbank uses the EnergyCore Management Engine to manage
voltages, it was not possible to use the cpufreq-cpu0 driver.

--Mark Langsdorf
Calxeda, Inc.

