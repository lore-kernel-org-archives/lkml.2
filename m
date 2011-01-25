Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1AYUA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:00:29 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:42694 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1AYUA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:00:28 -0500
Message-ID: <4D3F2BDB.7050508@pardus.org.tr>
Date: Tue, 25 Jan 2011 22:00:27 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101252038.25113.rjw@sisk.pl> <4D3F2869.3000406@pardus.org.tr> <201101252054.46647.rjw@sisk.pl>
In-Reply-To: <201101252054.46647.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> However, it would be good to check if the affected systems work with
> intel_idle + the above patch instead of acpi_idle.

My bad. I thought that I enabled intel_idle but it was not
driving those processors but it seems that I've not enabled it on those 
kernels.

Okay, ASAP I'll report back what's going on with intel_idle + the
patch that you gave.


-- 
Pardus Linux
http://www.pardus.org.tr/eng
