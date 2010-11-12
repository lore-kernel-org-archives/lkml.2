Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0KLHvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:51:13 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33799 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0KLHvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pekbt1z21MwMgwokAuNLS6SSrEqs5eYWoTN5jbukKOmilREtOJq+RurDronoYYJXt6
         u3Ag0YuTmo5GYPAqheN3poRaXxInSlkR8DPdiTPMB3v6oKSP5tw9vVbGSTvO7Nm1fga4
         71aKPPaR9SvyZLEwQnQyOBSHrLorV2bbLxh9M=
MIME-Version: 1.0
In-Reply-To: <87hbfnx2zw.fsf@deeprootsystems.com>
References: <1289484812-17278-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<87hbfnx2zw.fsf@deeprootsystems.com>
Date: Fri, 12 Nov 2010 09:51:11 +0200
Message-ID: <AANLkTimL25m4X0Apynis-H7g7FVDLU7Cw8mV+q2fptK8@mail.gmail.com>
Subject: Re: [PATCHv2] OMAP: Serial: Define OMAP uart MDR1 register definitions
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 11, 2010 at 6:02 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com> writes:
>
>> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
>>
>> Define MDR1 register serial definitions used in serial and
>> bluetooth drivers. Remove magic numbers there.
>
> Remove magic numbers where?  This patch doesn't remove anything.

We have code which is not yet upstream, it will come through Bluetooth
subtree at some point, I am also going to remove magic in
omapX/serial.c drivers in the next patches.

Do you think I need to add those patches?

>
>> *v2   added OMAP keyword
>
> This info should go after the '---' as it is not needed in the final
> git history.

OK, will remove it.

>
> Kevin
>
>> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
>> ---
>>  include/linux/serial_reg.h |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
>> index c7a0ce1..6f38234 100644
>> --- a/include/linux/serial_reg.h
>> +++ b/include/linux/serial_reg.h
>> @@ -341,5 +341,17 @@
>>  #define UART_OMAP_SYSS               0x16    /* System status register */
>>  #define UART_OMAP_WER                0x17    /* Wake-up enable register */
>>
>> +/*
>> + * These are the definitions for the MDR1 register
>> + */
>> +#define UART_OMAP_MDR1_16X_MODE              0x00    /* UART 16x mode */
>> +#define UART_OMAP_MDR1_SIR_MODE              0x01    /* SIR mode */
>> +#define UART_OMAP_MDR1_16X_ABAUD_MODE        0x02    /* UART 16x auto-baud */
>> +#define UART_OMAP_MDR1_13X_MODE              0x03    /* UART 13x mode */
>> +#define UART_OMAP_MDR1_MIR_MODE              0x04    /* MIR mode */
>> +#define UART_OMAP_MDR1_FIR_MODE              0x05    /* FIR mode */
>> +#define UART_OMAP_MDR1_CIR_MODE              0x06    /* CIR mode */
>> +#define UART_OMAP_MDR1_DISABLE               0x07    /* Disable (default state) */
>> +
>>  #endif /* _LINUX_SERIAL_REG_H */
>
