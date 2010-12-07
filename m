Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0LGUHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:07:49 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:39417 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab0LGUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:07:48 -0500
Message-ID: <4CFE93C6.7020808@euromail.se>
Date: Tue, 07 Dec 2010 21:06:30 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hid: egalax: Convert to MT slots
References: <1291722851-22909-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1012071554050.14806@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1012071554050.14806@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQ3nz-0007fF-Ay.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQ3nz-0007fF-Ay 7eb9da499e30b1657468b142a6491d16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 03:54 PM, Jiri Kosina wrote:

> On Tue, 7 Dec 2010, Henrik Rydberg wrote:
> 
>> The firmware in the joojoo reports touches sequentially, one per
>> report, which confuses the current driver. A further complication is
>> the absense of any indication of a touch frame. This patch converts
>> the driver to the MT slots protocol, and outputs one full touch frame
>> per report. This way, proper handling for both firmwares is ensured.
>>
>> Tested-by: Philipp Merkel <mail@philmerk.de>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Thanks,
> 


Much obliged. As agreed, will appear through Dmitry's tree.

Thanks,
Henrik

