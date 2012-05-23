Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2EWPxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:53:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47127 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2EWPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205221209530.2100-100000@iolanthe.rowland.org>
	<CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
Date: Wed, 23 May 2012 23:53:42 +0800
X-Google-Sender-Auth: t4o3EI7Nsqy_JkL2sXo-TahYP4o
Message-ID: <CAF1ivSa_Hz30mRXDmOAXuvOORAn8mA20XgoAouYoMysEXcwHpg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 4:29 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Wed, May 23, 2012 at 12:10 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> On Tue, 22 May 2012, Lin Ming wrote:
>>
>>> Hi,
>>>
>>> In August 2010, Jens and Alan discussed about "Runtime PM and the block
>>> layer". http://marc.info/?t=128259108400001&r=1&w=2
>>>
>>> Here are the RFC v3 patches that try to implement the ideas discussed.
>>> Welcome to give it a try.
>>
>> Have you checked to make sure these changes won't break the IDE driver?
>> Maybe it will need to set the REQ_PM flag too.

REQ_PM flag is about runtime PM, but IDE driver does not support
runtime PM at all.

# grep runtime drivers/ide/*.c

This gets empty result.

So I think it won't break the IDE driver.

Thanks,
Lin Ming

>
> Will check it.
>
> Another thing need to check is if system suspend/resume works.
>
>>
>> Alan Stern
