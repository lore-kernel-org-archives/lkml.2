Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2IEIT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:19:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37412 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2IEIT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120904193018.GA4176@kroah.com>
References: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
	<20120904193018.GA4176@kroah.com>
Date: Wed, 5 Sep 2012 17:19:54 +0900
Message-ID: <CAOTypNSdRQELkiscBsF1J7ZuXCNKPhJqPygeeopQ5+RB_hF1Wg@mail.gmail.com>
Subject: Re: [PATCH] staging/rts_pstor: remove braces {} in sd.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 4:30 AM, Greg Kroah-Hartman <greg@kroah.com> wrote:
> On Sat, Sep 01, 2012 at 10:43:00PM +0900, Toshiaki Yamane wrote:
>> fixed below checkpatch warnings.
>> -WARNING: braces {} are not necessary for single statement blocks
>> -WARNING: braces {} are not necessary for any arm of this statement
>>
>> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
>> ---
>>  drivers/staging/rts_pstor/sd.c | 1112 +++++++++++++++++-----------------------
>>  1 file changed, 469 insertions(+), 643 deletions(-)
>
> Why is the object file size changing with this patch applied?  That
> implies that something went wrong with your patch, care to redo it in a
> format that I can properly review it?

I understand.
I will redo it.

Thanks
