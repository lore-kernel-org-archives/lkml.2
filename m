Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3AEUMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 15:12:51 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:40438 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3AEUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 15:12:49 -0500
Message-ID: <50E8893E.8090502@lwfinger.net>
Date: Sat, 05 Jan 2013 14:12:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Woody Suwalski <terraluna977@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.8-rc[12] cpufreq build errors...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woody,

There is a patch pending that fixes this problem. See
http://lkml.indiana.edu/hypermail/linux/kernel/1212.3/01201.html. Note that 
Rafael wrote "If you don't mind, I'll rename CONFIG_CPU_FREQ_GOVERNOR to
CONFIG_CPU_FREQ_GOV_COMMON when applying it, though". I think this patch is 
working its way through the system, but I have not seem it in mainline yet.

Larry
