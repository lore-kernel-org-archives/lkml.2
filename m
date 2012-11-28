Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2K1Pb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:31:27 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65334 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2K1Pb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B3A9B501755@SAFEX1MAIL4.st.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>
	<20121126174632.GA12737@ennui.austin.ibm.com>
	<35286B1AE75A7C47BFF0870081A31B4B3A9B501754@SAFEX1MAIL4.st.com>
	<CAM0nabFLeW+1krAQxk=FPBAjSag7Jbwgkh=6vVWV_iXy2ULm0Q@mail.gmail.com>
	<35286B1AE75A7C47BFF0870081A31B4B3A9B501755@SAFEX1MAIL4.st.com>
Date: Wed, 28 Nov 2012 09:31:23 -0600
Message-ID: <CAM0nabHCCr2Dxv=smYvSFg3nD+keOhHY8+RD=7Q5uWkw6xS3AA@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
From: Kent Yoder <shpedoikal@gmail.com>
To: Mathias LEBLANC <Mathias.LEBLANC@st.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Sirrix AG <tpmdd@sirrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 2:54 AM, Mathias LEBLANC <Mathias.LEBLANC@st.com> wrote:
> Hi Kent,
>
> I have been tried the patch on your linux branch and indeed, i have an error about tpm_continue_seftest.
> What is the kernel I should use to test officially my patch? Because i saw a lot of different version of linux kernel with the tpm_continue_seftest function.
> I used this repo git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6 for my tests.

  The tree url I sent you is the correct one. Make sure you use the
"next" branch.

Kent

> Matthias Leblanc
>
> ________________________________________From: Kent Yoder [shpedoikal@gmail.com]
> Sent: 27 November 2012 15:48
> To: Mathias LEBLANC
> Cc: Kent Yoder; Jean-Luc BLANC; linux-kernel@vger.kernel.org; Rajiv Andrade; tpmdd-devel@lists.sourceforge.net; Sirrix AG
> Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
>
> On Tue, Nov 27, 2012 at 2:44 AM, Mathias LEBLANC <Mathias.LEBLANC@st.com> wrote:
>> Hi Kent,
>>
>> What's version of the kernel do you compiled?
>> I don't understand why you have some problem with formating, i have send you the patch with no error and warning of code formating.
>> The tpm_continue_selftest_nocheck()  (in kernel 3.x.x) and tpm_continue_selftest() (in kernel 2.6.x) is called to have the tpm ready.
>> If the tpm_continue_selftest is not called by the driver, it will be use in the applications.
>
> Apply against this tree's "next" branch.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
>
> Thanks,
> Kent
>
>> Regards,
>>
>> Matthias Leblanc
>> ________________________________________
>> From: Kent Yoder [key@linux.vnet.ibm.com]
>> Sent: 26 November 2012 18:46
>> To: Mathias LEBLANC
>> Cc: Rajiv Andrade; Marcel Selhorst; Sirrix AG; tpmdd-devel@lists.sourceforge.net; Debora Velarde; linux-kernel@vger.kernel.org; Jean-Luc BLANC
>> Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
>>
>> Hi Mathias,
>>
>> On Mon, Nov 19, 2012 at 11:15:21PM +0100, Mathias Leblanc wrote:
>>>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>>>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>>>  * This is free software, and you are welcome to redistribute it
>>>  * under certain conditions.
>>
>>> This is the driver for TPM chip from ST Microelectronics.
>>>
>>> If you have a TPM security chip from STMicroelectronics working with
>>> an I2C, in menuconfig or .config choose the tpm driver on
>>> device --> tpm and activate the protocol of your choice before compiling
>>> the kernel.
>>> The driver will be accessible from within Linux.
>>>
>>> Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS
>>> on kernel 3.x.x
>>>
>>> Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>
>>> ---
>>>  drivers/char/tpm/tpm_stm_st33_i2c.c  |  903 ++++++++++++++++++++++++++++++++++
>>>  drivers/char/tpm/tpm_stm_st33_i2c.h  |   81 +++
>>>  include/linux/i2c/tpm_stm_st33_i2c.h |   47 ++
>>>  3 files changed, 1031 insertions(+)
>>>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.c
>>>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.h
>>>  create mode 100644 include/linux/i2c/tpm_stm_st33_i2c.h
>>
>>   I'm still getting the compiler errors I mentioned earlier. I've fixed
>> them up with the patch below (plus some formatting), all except for the
>> tpm_continue_selftest_nocheck() problem. Do you really need to call
>> continue selftest on resume?  That strikes me as out of place here.
>> What's making the call to the TPM to start the self test in that case?
>>
>> Please test with the patch below.
>>
>> Thanks,
>> Kent
>>
>>
>> diff --git a/drivers/char/tpm/tpm_stm_st33_i2c.c b/drivers/char/tpm/tpm_stm_st33_i2c.c
>> index 52f3380..67f81b6 100644
>> --- a/drivers/char/tpm/tpm_stm_st33_i2c.c
>> +++ b/drivers/char/tpm/tpm_stm_st33_i2c.c
>> @@ -722,7 +722,7 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
>>                         goto _irq_set;
>>
>>                 intmask = TPM_GLOBAL_INT_ENABLE;
>> -               err = I2C_WRITE_DATA(client, TPM_INT_ENABLE + 3, &intmask, 1);
>> +               err = I2C_WRITE_DATA(client, (TPM_INT_ENABLE + 3), &intmask, 1);
>>                 if (err < 0)
>>                         goto _irq_set;
>>
>> @@ -820,10 +820,10 @@ static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
>>
>>         if (power_mgt)
>>                 gpio_set_value(pin_infos->io_lpcpd, 0);
>> -       else{
>> +       else {
>>                 if (chip->data_buffer == NULL)
>>                         chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
>> -               ret = tpm_pm_suspend(&client->dev, mesg);
>> +               ret = tpm_pm_suspend(&client->dev);
>>         }
>>         return ret;
>>  }                              /* tpm_st33_i2c_suspend() */
>> @@ -848,12 +848,12 @@ static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
>>                                           (chip->vendor.status(chip) &&
>>                                           TPM_STS_VALID) == TPM_STS_VALID,
>>                                           chip->vendor.timeout_b);
>> -       } else{
>> -       if (chip->data_buffer == NULL)
>> -               chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
>> -       ret = tpm_pm_resume(&client->dev);
>> -       if (!ret)
>> -               tpm_continue_selftest_nocheck(chip);
>> +       } else {
>> +               if (chip->data_buffer == NULL)
>> +                       chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
>> +               ret = tpm_pm_resume(&client->dev);
>> +               if (!ret)
>> +                       tpm_continue_selftest_nocheck(chip);
>>         }
>>         return ret;
>>  }                              /* tpm_st33_i2c_pm_resume() */
>>
>> ------------------------------------------------------------------------------
>> Monitor your physical, virtual and cloud infrastructure from a single
>> web console. Get in-depth insight into apps, servers, databases, vmware,
>> SAP, cloud infrastructure, etc. Download 30-day Free Trial.
>> Pricing starts from $795 for 25 servers or applications!
>> http://p.sf.net/sfu/zoho_dev2dev_nov
>> _______________________________________________
>> tpmdd-devel mailing list
>> tpmdd-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>
>
>
> --
> IBM LTC Security



-- 
IBM LTC Security
