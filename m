Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3ADQf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:35:26 -0500
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:54589 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3ADQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:35:24 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4 v10] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Fri,  4 Jan 2013 10:35:42 -0600
Message-Id: <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds cpufreq support for the Calxeda
ECX-1000 (highbank) SoCs. The EnergyCore Management Engine (ECME) on
the ECX-1000 manages the voltage for the part and communications with
Linux through a pl320 mailbox. clk notifications are used to control
when to send messages to the ECME.

Previous versions of this patch set include two other patches. One has
been dropped as unworkable and the other got picked up and included in
3.8.0.

--Mark Langsdorf
Calxeda, Inc.

