Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1DTVso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:48:44 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:12450 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1DTVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:48:43 -0400
Message-ID: <4DAF5497.9070404@chelsio.com>
Date: Wed, 20 Apr 2011 14:48:07 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, Dimitris Michailidis <dm@chelsio.com>,
        Neil Horman <nhorman@tuxdrivers.com>
Subject: [PATCH] linux-firmware: add cxgb4 firmware file
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Apr 2011 21:48:37.0357 (UTC) FILETIME=[B43961D0:01CBFFA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Can you please pull from git://git.chelsio.net/pub/git/linux-firmware.git?

It contains the following commit, adding the firmware file for the cxgb4 
ethernet driver.

commit cbcdb42c039ae166378555329e9b3a22606bf584
Author: divy <divy@bo.asicdesigners.com>
Date:   Wed Apr 20 14:15:22 2011 -0700

     linux-firmware: add cxgb4 firmware

     Add firmware file for Chelsio Termninator 4 ethernet controller

     Signed-off-by: Divy Le Ray <divy@chelsio.com>

Cheers,
Divy
