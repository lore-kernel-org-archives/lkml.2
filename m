Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2KGSK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:10:58 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:53727 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2KGSK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:10:56 -0500
Message-ID: <509AA434.80702@calxeda.com>
Date: Wed, 07 Nov 2012 12:11:00 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH 0/6 v3] cpufreq: add support for Calxeda ECX-1000 (highbank)
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1352233089-22586-1-git-send-email-mark.langsdorf@calxeda.com>
In-Reply-To: <1352233089-22586-1-git-send-email-mark.langsdorf@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 02:18 PM, Mark Langsdorf wrote:
> This patch series adds cpufreq support for the Calxeda
> ECX-1000 (highbank) SoCs. The driver is based on the 
> cpufreq-cpu0 driver. Because of the unique way that 
> highbank uses the EnergyCore Management Engine to manage
> voltages, it was not possible to use the cpufreq-cpu0 driver.

I accidentally sent out old versions of the patches. Please ignore the
v3 series and look at the v4 instead.

--Mark Langsdorf

