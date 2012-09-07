Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2IGCac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:30:32 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62895 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab2IGCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120904193018.GA4176@kroah.com>
References: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
	<20120904193018.GA4176@kroah.com>
Date: Fri, 7 Sep 2012 11:30:29 +0900
Message-ID: <CAOTypNTmPmqQPS56EwT8FFfx3yvrzQd5Mk74HGjYosCL4whn6Q@mail.gmail.com>
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

I had to remove the brace that I must not be deleted.
I will send a patch later.

@@ -2729,15 +2644,13 @@ static int mmc_test_switch_bus(struct | @@
-2729,9 +2611,8 @@ static int mmc_test_switch_bus(struct r
        rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD
 rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD

        rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2, 0, 0);
 rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2, 0, 0);
-       if (width == MMC_8BIT_BUS) {                            -
 if (width == MMC_8BIT_BUS) {
+       if (width == MMC_8BIT_BUS)                              +
 if (width == MMC_8BIT_BUS)
                rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2
         rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2
-       }                                                       -       }

        retval = rtsx_send_cmd(chip, SD_CARD, 100);
 retval = rtsx_send_cmd(chip, SD_CARD, 100);
-       if (retval < 0) {                                     |
 if (retval < 0) {
+       if (retval < 0)                                       | @@
-2747,15 +2628,14 @@ static int mmc_test_switch_bus(struct
                rtsx_clear_sd_error(chip);                    <
                TRACE_RET(chip, SWITCH_ERR);                  <
-       }                                                     <
                                                              <
        ptr = rtsx_get_cmd_data(chip) + 1;                    <
                                                              <
@@ -2747,15 +2660,15 @@ static int mmc_test_switch_bus(struct <
