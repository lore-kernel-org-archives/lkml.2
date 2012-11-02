Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab2KBVlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:41:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53112 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab2KBVla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:41:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Fri, 02 Nov 2012 22:45:36 +0100
Message-ID: <1835379.6Ci8lTl9hk@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, November 02, 2012 01:51:43 PM Mark Langsdorf wrote:
> This patch series adds cpufreq support for the Calxeda ECX-1000 (highbank)
> SoCs. The driver is based on the cpufreq-cpu0 driver. Because of the 
> unique way that highbank uses the EnergyCore Management Engine to manage
> voltages, it was not possible to use the cpufreq-cpu0 driver.

Can you please resend the whole series with CCs to linux-pm@vger.kernel.org,
so that the patches are accessible to me through Patchwork?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
