Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1BYNXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:23:25 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41719 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab1BYNXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:23:24 -0500
Message-ID: <4D67ACFA.4090600@mvista.com>
Date: Fri, 25 Feb 2011 16:22:02 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Pratheesh Gangadhar <pratheesh@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, gregkh@suse.de,
        tglx@linutronix.de, arnd@arndb.de, amit.chatterjee@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used
 by PRUSS UIO driver
References: <1298556402-26456-1-git-send-email-pratheesh@ti.com> <1298556402-26456-2-git-send-email-pratheesh@ti.com> <1298556402-26456-3-git-send-email-pratheesh@ti.com> <4D6796D6.5050008@mvista.com> <20110225130241.GA2791@local>
In-Reply-To: <20110225130241.GA2791@local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-02-2011 16:02, Hans J. Koch wrote:

>>> This patch defines PRUSS, ECAP clocks, memory and IRQ resources
>>> used by PRUSS UIO driver in DA850/AM18xx/OMAPL1-38 devices. UIO

>>     It's OMAP-L138.

> From the TI wiki: "The PRU subsystem is supported on
> OMAP-L1x8/C674m/AM18xx devices (where m is an even number)."

> http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem

    I meant there's a typo in "OMAPL1-38".

> Thanks,
> Hans

WBR, Sergei
