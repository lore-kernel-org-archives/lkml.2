Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1KBOwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:52:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33607 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1KBOwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:52:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_0eY2HGQNgXOeH13v5Ba47JiO-oY2mSxnfyLQTegQDzNQ@mail.gmail.com>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
 <1319487676-27181-2-git-send-email-ricardo.ribalda@gmail.com>
 <20111024213104.GA4394@ponder.secretlab.ca> <CAPybu_3EPJYd1EdzgF1oF6_k8u5nr4Kx1zmdPRXNZ_zcACrUEw@mail.gmail.com>
 <CACxGe6uAMugBRAqeN5D-HfX4G+DysLFjfp7=ZeC378cAdwOAwA@mail.gmail.com> <CAPybu_0eY2HGQNgXOeH13v5Ba47JiO-oY2mSxnfyLQTegQDzNQ@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 2 Nov 2011 15:51:42 +0100
Message-ID: <CAPybu_30aorqCzvXhUWHZeBc7D1mfqzAR0c13R5rKL3GL1-WVA@mail.gmail.com>
Subject: Re: [PATCHv4 1/6] input/cma3000_d0x: Support devices without pdata
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        jic23@cam.ac.uk, aghayal@codeaurora.org, david@hardeman.nu,
        Shubhrajyoti@ti.com, saaguirre@ti.com, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, found it, and implement it.... Please check the new patchset :)

Thanks

On Wed, Nov 2, 2011 at 13:41, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello Grant
>  Thanks for your feedback
>
>>>> No of_device_id match table to match against compatible values?
>>>
>>> I think it is not needed, the device will be matched against the
>>> driver cma3000_d0x_spi.c and AFAIK on the spi/i2c devices you dont
>>> need the device_id match. But you know much more about this :).  Can
>>> you point me to a example where a spi driver uses of_device-id match.
>>
>> Use an of_device_id table.  It's the right thing to do.
>>
> Can you point me to a file where of_device_id is used in a spi/i2c
> driver? I thought that was only for mmaped drivers....
>
>
> Thanks!
>
>
> --
> Ricardo Ribalda
>



-- 
Ricardo Ribalda
