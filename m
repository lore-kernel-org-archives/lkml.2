Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2KFUSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:18:22 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:44717 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2KFUSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:18:17 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, mark.langsdorf@calxeda.com
Subject: [PATCH 0/6 v3] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Tue,  6 Nov 2012 14:18:02 -0600
Message-Id: <1352233089-22586-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds cpufreq support for the Calxeda
ECX-1000 (highbank) SoCs. The driver is based on the 
cpufreq-cpu0 driver. Because of the unique way that 
highbank uses the EnergyCore Management Engine to manage
voltages, it was not possible to use the cpufreq-cpu0 driver.

--Mark Langsdorf


