Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab2GDHvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:51:44 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38769 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2GDHvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:51:43 -0400
Message-ID: <4FF3F603.6080401@ahsoftware.de>
Date: Wed, 04 Jul 2012 09:51:31 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: linux-kernel@vger.kernel.org, Shuah Khan <shuahkhan@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] leds: heartbeat: fix bug on panic
References: <20120612162629.15519f39@feng-i7> <1341297347-19336-1-git-send-email-holler@ahsoftware.de> <CAK5ve-JCEeuhmqB=ruy78nCgma7ENL-48N+p5=nhz3e0exS9yg@mail.gmail.com> <4FF3EC87.4090001@ahsoftware.de> <CAK5ve-LZdCtUC3inX9S-UGwHBLxS-hqLmmUBOkTBn-9Z--7oPw@mail.gmail.com>
In-Reply-To: <CAK5ve-LZdCtUC3inX9S-UGwHBLxS-hqLmmUBOkTBn-9Z--7oPw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.07.2012 09:29, schrieb Bryan Wu:

> Anyway, I will apply this patch to my for-next branch.

Is it already too late for 3.5 (where I introduced the bug)? I know I 
should have reacted faster, but I the bug report got down under a ton of 
other mails. ;)

Regards,

Alexander
