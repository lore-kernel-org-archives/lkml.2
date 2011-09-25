Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1IYJvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 05:51:33 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3035 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762Ab1IYJvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 05:51:32 -0400
Message-ID: <4E7EFA42.4030608@hetnet.nl>
Date: Sun, 25 Sep 2011 11:54:10 +0200
From: Henk de Groot <henk.de.groot@hetnet.nl>
Reply-To: henk.de.groot@hetnet.nl
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: David Kilroy <kilroyd@googlemail.com>
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 0/4] staging: wlags49_h2: WEXT cleanups
References: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Sep 2011 09:51:29.0955 (UTC) FILETIME=[B3295F30:01CC7B68]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 25-9-2011 9:30, David Kilroy schreef:
> These are some fixes found while verifying the driver has been updated
> for changes between WEXT v15 and 21. IOCTLs used for WEP look like
> they should work. WPA related IOCTLS look like more work is needed
> (but WPA is known to be be broken with this driver).

Patches applied to test driver (only 3/4 failed because I applied the 
v15->v21 patch before). Driver compiles and runs okay using WEP as it did 
before. Tested on kernel 2.6.38-11-generic #50-Ubuntu.

Henk.

