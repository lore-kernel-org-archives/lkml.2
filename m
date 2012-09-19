Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2ISLyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:54:10 -0400
Received: from relay.ihostexchange.net ([66.46.182.53]:36463 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab2ISLyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:54:07 -0400
Message-ID: <5059B254.7090600@cypress.com>
Date: Wed, 19 Sep 2012 14:53:56 +0300
From: Ferruh Yigit <fery@cypress.com>
Organization: Cypress
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, Phil Warkentin <pwar@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Input: cyttsp4 - driver for Cypress TMA4XX touchscreen
 devices
References: <fery@cypress.com> <1347644917-13269-1-git-send-email-fery@cypress.com> <20120914184636.GA2976@polaris.bitmath.org>
In-Reply-To: <20120914184636.GA2976@polaris.bitmath.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 09:46 PM, Henrik Rydberg wrote:
> Hi Ferruh,
>
>> This driver is for Cypress TrueTouch(tm) Standard Product controllers,
>> Generation4 devices.
>>
>> This is second version of driver, code re-structured to match with
>> existing Generation3 driver code.
> To integrate with the existing gen3 driver is clearly not the same as
> creating a parallel set of files, which obviously share a lot of code
> with the gen3 code.
>
> For instance, the i2c transfer layer seems more or less identical to
> the existing one; just look at cyttsp_i2c_write_block_data() versus
> cyttsp4_i2c_write_block_data(). If different generations of device
> data cannot even be transported through the same _generic_ interface,
> something is clearly not right.
>
> You can't seriously expect anyone to want to maintain one set of files
> for every new version. Please make sure to build on what is already
> there.
>
> Thanks.
> Henrik
Hi Henrik,

Thank you for your review.

We will work on merging transfer layers of drivers and submit a new set
of patches.


Thanks and Regards,
ferruh

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
