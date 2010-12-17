Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab0LQHGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 02:06:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:30383 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LQHGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 02:06:19 -0500
Message-ID: <4D0B0B70.9050306@oracle.com>
Date: Fri, 17 Dec 2010 15:04:16 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexander Indenbaum <baum@tehutinetworks.net>,
        Andy Gospodarek <andy@greyhouse.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Joe Jin <joe.jin@oracle.com>
Subject: [NETWORK] Firmware file for tehuti
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Regarding firmware for driver tehuti, it request firmware name is
tehuti/firmware.bin,
but from kernel source found no such file but have tehuti/bdx.bin.ihex,
so the firmware
should be bdx.bin rather than firmware.bin?

Thanks,
Joe

-- 
Oracle <http://www.oracle.com>
Joe Jin | Team Leader, Software Development | +8610.8278.6295
ORACLE | Linux and Virtualization
Incubator Building 2-A ZPark | Beijing China, 100094

