Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2JaARu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:17:50 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47177 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2JaARt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:17:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/6] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Wed, 31 Oct 2012 01:21:52 +0100
Message-ID: <2214794.7VrBWCJZol@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2012 04:04:10 PM Mark Langsdorf wrote:
> This patch series adds cpufreq support for the Calxeda ECX-1000 (highbank)
> SoCs. The driver is based on the cpufreq-cpu0 driver. Because of the 
> unique way that highbank uses the EnergyCore Management Engine to manage
> voltages, it was not possible to use the cpufreq-cpu0 driver.

I've got patches [3-6/6] only for some reason.  Care to resend the other three
with direct CCs to me?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
