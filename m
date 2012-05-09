Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2EIF2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:28:49 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:56814 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750986Ab2EIF2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4HGVGRbnLCMOAbO1mYnFCgHhh1_ErLdKq5YhMdV0VhQw@mail.gmail.com>
References: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
	<1333956052-25319-2-git-send-email-tinamdar@apm.com>
	<CA+5PVA4HGVGRbnLCMOAbO1mYnFCgHhh1_ErLdKq5YhMdV0VhQw@mail.gmail.com>
Date: Wed, 9 May 2012 10:58:46 +0530
Message-ID: <CACoXjcn1H_Jov86a5fmonY-5CtKCcGgBHMwzUf-i-66-VatqJw@mail.gmail.com>
Subject: Re: [V2 2/5] powerpc: 40x: Add AHB, APB of_device_ids
From: Tanmay Inamdar <tinamdar@apm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: benh@kernel.crashing.org, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 7:11 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Mon, Apr 9, 2012 at 3:20 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>> Adding of_device_id's for AHB and APB buses used in klondike (APM8018X) in
>> platforms/40x/ppc40x_simple.c file
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>
> You should probably combine the first 3 patches in this series into one
> patch.  Otherwise you run the risk of changing the DTS to something the
> kernel can't support.  At the least, this change should be patch 1 in
> the series, and you can probably combine the two DTS changes.
>

I will do it in next version of patches.

> josh

Thanks,
Tanmay
CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, 
is for the sole use of the intended recipient(s) and contains information 
that is confidential and proprietary to AppliedMicro Corporation or its subsidiaries. 
It is to be used solely for the purpose of furthering the parties' business relationship. 
All unauthorized review, use, disclosure or distribution is prohibited. 
If you are not the intended recipient, please contact the sender by reply e-mail 
and destroy all copies of the original message.


