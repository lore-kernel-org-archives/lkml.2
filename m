Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1AYTpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:45:47 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:37041 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1AYTpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:45:45 -0500
Message-ID: <4D3F2869.3000406@pardus.org.tr>
Date: Tue, 25 Jan 2011 21:45:45 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D3DDDA4.2080202@yahoo.fr> <201101250822.48287.ozan@pardus.org.tr> <201101252038.25113.rjw@sisk.pl>
In-Reply-To: <201101252038.25113.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2011 21:38, Rafael J. Wysocki wrote:

> Does
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ec30f343d61391ab23705e50a525da1d55395780
> generally help?

Well I can let them try a patched kernel but will a kernel showing 
acpi_idle as the cpuidle driver in dmesg will be affected by this patch?
I can't see any sign on reporters' dmesg that intel_idle is active.



-- 
Pardus Linux
http://www.pardus.org.tr/eng
