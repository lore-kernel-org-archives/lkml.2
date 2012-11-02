Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935333Ab2KBSvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:51:44 -0400
Received: from smtp145.dfw.emailsrvr.com ([67.192.241.145]:43384 "EHLO
	smtp145.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761234Ab2KBSvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:51:42 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org
Subject: [PATCH 0/6 v2] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Fri,  2 Nov 2012 13:51:43 -0500
Message-Id: <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds cpufreq support for the Calxeda ECX-1000 (highbank)
SoCs. The driver is based on the cpufreq-cpu0 driver. Because of the 
unique way that highbank uses the EnergyCore Management Engine to manage
voltages, it was not possible to use the cpufreq-cpu0 driver.

--Mark Langsdorf

