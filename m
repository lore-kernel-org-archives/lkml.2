Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1A2RtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 12:49:12 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:46770 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1A2RtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 12:49:10 -0500
Message-ID: <4D445319.5020803@pardus.org.tr>
Date: Sat, 29 Jan 2011 19:49:13 +0200
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

On 25.01.2011 21:54, Rafael J. Wysocki wrote:

>
> If intel_idle is not active, then the patch will not help.
>
> However, it would be good to check if the affected systems work with
> intel_idle + the above patch instead of acpi_idle.

intel_idle enabled and the patch above applied. Got 1 feedback for now 
which tells that 1 out of 2 shutdown attempts failed. This is on Asus 
N61JQ (https://bugzilla.kernel.org/show_bug.cgi?id=27412).


-- 
Pardus Linux
http://www.pardus.org.tr/eng
