Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2L0NHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 08:07:36 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46182 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab2L0NHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 08:07:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6 v8] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Thu, 27 Dec 2012 14:12:58 +0100
Message-ID: <2705062.NIaFfcLb3a@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1354726121-17190-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1354726121-17190-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 05, 2012 10:48:35 AM Mark Langsdorf wrote:
> This patch series adds cpufreq support for the Calxeda
> ECX-1000 (highbank) SoCs. The EnergyCore Management Engine (ECME) on
> the ECX-1000 manages the voltage for the part and communications with
> Linux through a pl320 mailbox. clk notifications are used to control
> when to send messages to the ECME.

If you want me to handle this, can you please resend the whole patchset (with
all of the comments addressed, if possible)?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
