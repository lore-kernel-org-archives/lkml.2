Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1BGRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:09:28 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:59075 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab1BGRJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:09:27 -0500
Message-ID: <4D502746.4030500@pardus.org.tr>
Date: Mon, 07 Feb 2011 19:09:26 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: A lot of [ext4-dio-unwrit] threads around
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is 2.6.35.11 on a 24-core HP Proliant server with 8 mounted ext4 
filesystems. There are 7 LXC containers which does heavy compiling 
workload during the day.

Uptime is 3 days and currently there are 216 ext4-dio-unwrit threads in 
ps aux output? Is it normal or a symptom of a problem?

Thanks
-- 
Pardus Linux
http://www.pardus.org.tr/eng
