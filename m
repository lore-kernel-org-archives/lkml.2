Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2ALGGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:06:52 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62008 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2ALGGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f0dc4f1ec60a3.38796665@nextmail.ru>
References: <NEXT-4f0dc4f1ec60a3.38796665@nextmail.ru>
Date: Thu, 12 Jan 2012 11:36:48 +0530
Message-ID: <CAD2nsn3_WT96V_ZS217ph4gX7cGEAPtg0Ncq6cmSAwbEbGhRcw@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/11 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
>> does roaming seems to trigger this issue consistently ?
>> . please provide the logs
>> sudo modprobe -v ath9k debug=0xffffffff
>> http://linuxwireless.org/en/users/Drivers/ath9k/debug
>
> As I need to rebuild for CONFIG_ATH_DEBUG: should I check the allegedely
> proper fix or wide-angle code removal first?

please check with the proper fix

-- 
shafi
