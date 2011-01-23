Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab1AWQtC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 11:49:02 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:39738 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1AWQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 11:49:00 -0500
Message-ID: <4D3C5C01.4040408@pardus.org.tr>
Date: Sun, 23 Jan 2011 18:49:05 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <4D3C3B1E.1080500@pardus.org.tr> <4D3C42A5.6060909@t-online.de>
In-Reply-To: <4D3C42A5.6060909@t-online.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2011 17:00, Richard Schütz wrote:

>
> Looks like these are all Intel machines. Do they use intel_idle for the
> CPU powersaving features?
> (cat /sys/devices/system/cpu/cpuidle/current_driver)

Well at least on F50SV and N61JQ they use acpi_idle (this is what dmesg 
output says).

I'll open a bug for N61JQ as I've got detailed information about it.


-- 
Pardus Linux
http://www.pardus.org.tr/eng
