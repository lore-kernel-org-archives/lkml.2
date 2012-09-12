Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2ILNRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:17:08 -0400
Received: from relay.ihostexchange.net ([66.46.182.53]:18418 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2ILNRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:17:05 -0400
Message-ID: <50508B45.40706@cypress.com>
Date: Wed, 12 Sep 2012 16:16:53 +0300
From: Ferruh Yigit <fery@cypress.com>
Organization: Cypress
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Input: cyttsp4 - bus driver for Cypress TMA4XX touchscreen
 devices
References: <fery@cypress.com> <1344344978-30453-1-git-send-email-fery@cypress.com> <50377C60.4020008@cypress.com> <20120824173408.GA6176@polaris.bitmath.org> <503B099A.6010807@cypress.com>
In-Reply-To: <503B099A.6010807@cypress.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 08:46 AM, Ferruh Yigit wrote:
> On 08/24/2012 08:34 PM, Henrik Rydberg wrote:
>> Hi Ferruh,
>>
>> As Javier mentioned, there is already a framework for the Cypress
>> devices in the kernel. Please make sure your patches build on what is
>> already there. Until then, I have nothing further to add.
>>
>> Thanks,
>> Henrik
>
> Hi Henrik,
>
> Thank you for your response.
>
> We now understand the requirement for our driver and we will submit a
> new patchset as soon as possible.
>
> Best Regards,
> ferruh
>

Hello Henrik,

After Javier's and your comment, we started an effort to update driver
and re-structured it similar to the existing Gen3 driver. We are close
to submit a patch-set for updated code, but this effort showed that this
new patch-set also won't be an incremental commit to existing driver but
will have to introduce new files.

Existing driver in the kernel is for Cypress Gen3 devices and it is not
a framework to cover Gen4 devices, Gen4 devices has different host
interface.

This re-structure made driver simpler with cost of removing some
features like ttsp bus or merging modular layers that work with
subscription mechanism into one file with direct function calls.
The concern here for our side is, the next generation touchscreen
controllers may cause similar problem with this Gen3 structure while
adding support to Linux kernel for them.

Before finalizing the work, we want to learn if introducing new files
for new driver is acceptable and our effort is inline with your request,
can you please comment on it?

Thanks and Regards,
ferruh

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
