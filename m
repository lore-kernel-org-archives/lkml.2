Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1AaIxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:53:24 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:55790 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1AaIxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:53:22 -0500
Message-ID: <4D467882.9060304@pardus.org.tr>
Date: Mon, 31 Jan 2011 10:53:22 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D445319.5020803@pardus.org.tr> <4D45CA6F.8000002@pardus.org.tr> <201101302348.40509.rjw@sisk.pl>
In-Reply-To: <201101302348.40509.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.01.2011 00:48, Rafael J. Wysocki wrote:

> Does booting with "nolapic" help on all of the affected systems?
>
> Also, does disabling the CPUidle during boot help?
>
> Finally, is the problem reproducible with CONFIG_NO_HZ unset?

Well on two machines, nolapic cures the boot hang and on one machine it 
cures the random shutdown hangs.

I'll compile a kernel with CONFIG_NO_HZ to see what happens but how do I 
disable cpuidle during boot? I've checked the kernel-parameters.txt but 
there's no cpuidle related boot parameter there.

Thanks


-- 
Pardus Linux
http://www.pardus.org.tr/eng
