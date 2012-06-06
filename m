Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab2FFU4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:56:15 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47577 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2FFU4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:56:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6734"; a="198458446"
Message-ID: <310175ff06fd45dca660047535666a61.squirrel@www.codeaurora.org>
Date: Wed, 6 Jun 2012 13:56:13 -0700 (PDT)
Subject: Re: [RFC/PATCH 1/1] mmc: block: Add MMC write packing statistics
From: merez@codeaurora.org
To: "Rahul Bedarkar" <rpal143@gmail.com>
Cc: "Maya Erez" <merez@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +       for (i = 1 ; i <= max_num_of_packed_reqs ; ++i) {
> This is something magical number for iterations. why can not we start
from
> zero.
The statistics are kept in the array in the index that equals the number
of packed requests. Therefore, they are kept in the array in indexes 1 to
max num of packed reqs.
I will add a comment to explain that.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum






