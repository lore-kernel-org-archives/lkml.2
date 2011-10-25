Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1JYHq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:46:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45807 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1JYHqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:46:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_3EPJYd1EdzgF1oF6_k8u5nr4Kx1zmdPRXNZ_zcACrUEw@mail.gmail.com>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
 <1319487676-27181-2-git-send-email-ricardo.ribalda@gmail.com>
 <20111024213104.GA4394@ponder.secretlab.ca> <CAPybu_3EPJYd1EdzgF1oF6_k8u5nr4Kx1zmdPRXNZ_zcACrUEw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Oct 2011 09:46:34 +0200
X-Google-Sender-Auth: 14kQbRueg0cQbXYaToavThzGm-4
Message-ID: <CACxGe6uAMugBRAqeN5D-HfX4G+DysLFjfp7=ZeC378cAdwOAwA@mail.gmail.com>
Subject: Re: [PATCHv4 1/6] input/cma3000_d0x: Support devices without pdata
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        jic23@cam.ac.uk, aghayal@codeaurora.org, david@hardeman.nu,
        Shubhrajyoti@ti.com, saaguirre@ti.com, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 9:38 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello Grant
>
>>> ---
>>
>> Drop this line, git cuts everything below a '---' line from the commit text.
>
> Done, thanks
>
>>
>> This binding needs documentation before it can be merged.
>
> Documentation/input/cma3000_d0x.txt is the right place ?

Documentation/devicetree/bindings/input

>> No of_device_id match table to match against compatible values?
>
> I think it is not needed, the device will be matched against the
> driver cma3000_d0x_spi.c and AFAIK on the spi/i2c devices you dont
> need the device_id match. But you know much more about this :).  Can
> you point me to a example where a spi driver uses of_device-id match.

Use an of_device_id table.  It's the right thing to do.

g.
