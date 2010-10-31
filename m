Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0JaIpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 04:45:21 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:32890 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0JaIpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 04:45:17 -0400
Message-ID: <4CCD2C7A.6020703@euromail.se>
Date: Sun, 31 Oct 2010 09:44:42 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 0/8] hwmon: applesmc: Dynamic configuration rewrite
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se> <1288513860.366.205.camel@Joe-Laptop>
In-Reply-To: <1288513860.366.205.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PCTWz-0006xo-BK.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PCTWz-0006xo-BK 732a863c24af5c67e155b79f5b3268d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2010 09:31 AM, Joe Perches wrote:

> On Sun, 2010-10-31 at 08:50 +0100, Henrik Rydberg wrote:
>> This patchset introduces dynamic configuration by making the SMC
>> register set efficiently searchable, and fixes a number of outstanding
>> issues:
> 
> Hi Henrik.
> 
> Your patches are built on top of a patch I submitted
> that wasn't accepted by Jean or Guenter.


Right. I imagine there will be new revisions of that patch. If we are all
targeting 2.6.38, I can certainly rebase this set back to the current head, if
that is preferrable. Jean?

Thanks,
Henrik
