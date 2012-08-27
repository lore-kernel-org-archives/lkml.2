Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2H0Ftu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 01:49:50 -0400
Received: from relay.ihostexchange.net ([66.46.182.53]:2776 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2H0Fts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 01:49:48 -0400
Message-ID: <503B0A74.9070809@cypress.com>
Date: Mon, 27 Aug 2012 08:49:40 +0300
From: Ferruh Yigit <fery@cypress.com>
Organization: Cypress
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Input: cyttsp4 - core driver for Cypress TMA4XX touchscreen
 devices
References: <Ferruh Yigit <fery@cypress.com> <1344345000-30494-1-git-send-email-fery@cypress.com> <50378DD1.9080806@suse.cz>
In-Reply-To: <50378DD1.9080806@suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 05:21 PM, Michal Marek wrote:
> Dne 7.8.2012 15:09, Ferruh Yigit napsal(a):
>> +static int __init cyttsp4_core_init(void)
>> +{
>> +       int rc = 0;
>> +
>> +       rc = cyttsp4_register_core_driver(&cyttsp4_core_driver);
>> +       pr_info("%s: Cypress TTSP v4 core driver (Built %s @ %s) rc=%d\n",
>> +                __func__, __DATE__, __TIME__, rc);
> Hi,
>
> please drop the __DATE__ and __TIME__ macros to keep the build
> deterministic.
>
> thanks,
> Michal

Thank you Michal,

Will replace them with fixed release date macro.

Regards,
ferruh

--

Regards,
ferruh


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
