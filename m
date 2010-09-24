Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0IXAvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:51:50 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:54689 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0IXAvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:51:49 -0400
Message-ID: <4C9BF624.7090906@hardwarefreak.com>
Date: Thu, 23 Sep 2010 19:51:48 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
References: <4C9BE5A8.1090002@teksavvy.com>
In-Reply-To: <4C9BE5A8.1090002@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord put forth on 9/23/2010 6:41 PM:
> What's the purpose of this stack dump,
> and how can it be prevented in this NORMAL situation??
> 
> The command was "hdparm --security-erase NULL /dev/sdb",
> which takes about 66 minutes to complete on this particular drive.
> 
> I don't see any obvious way for the task to mark itself
> as needing longer than 120 secs to complete the operation.

~$ man hdparm

ATA Security Feature Set

These switches are DANGEROUS to experiment with,
and might not work with every kernel. USE AT YOUR OWN RISK.

--security-erase PWD

THIS FEATURE IS EXPERIMENTAL AND NOT WELL TESTED.  USE  AT  YOUR
              OWN RISK.

-- 
Stan
