Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab2JLSYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:24:01 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54171 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921Ab2JLSYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:24:00 -0400
Message-ID: <5078603C.9010709@lwfinger.net>
Date: Fri, 12 Oct 2012 13:23:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Spurious warning in checkpatch.pl?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

The checkpatch.pl version in mainline is issuing what I think are false warnings 
of the type

WARNING: networking block comments put the trailing */ on a separate line
#93: FILE: drivers/net/wireless/rtlwifi/wifi.h:208:
+       u32 rf_rb;              /* rflssi_readback */

Is a trailing comment for the member of a struct not allowed?

Thanks,

Larry
