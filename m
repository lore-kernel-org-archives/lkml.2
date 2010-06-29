Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0F2MUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:20:38 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:52103 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751472Ab0F2MUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:20:37 -0400
From: Rupjyoti Sarmah <rsarmah@apm.com>
References: <201006041226.o54CQH2V017366@amcc.com> <201006290333.50673.marek.vasut@gmail.com>
In-Reply-To: <201006290333.50673.marek.vasut@gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcsXK3Xxtp3d2Yn/Q8SYEjiVjmfbXQAWP2gw
Date: Tue, 29 Jun 2010 17:50:32 +0530
Message-ID: <5db514a6e3b22cd59eeaa1acc716be5a@mail.gmail.com>
Subject: RE: [PATCH]460EX on-chip SATA driver<kernel 2.6.33><resubmission>
To: Marek Vasut <marek.vasut@gmail.com>, Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       sr@denx.de, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your feedback. I submitted an updated version of this patch
later.
I tried to limit the lines within 80 characters.

Regards,
Rup


-----Original Message-----
From: Marek Vasut [mailto:marek.vasut@gmail.com]
Sent: Tuesday, June 29, 2010 7:04 AM
To: Rupjyoti Sarmah
Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org;
jgarzik@pobox.com; sr@denx.de; linuxppc-dev@ozlabs.org
Subject: Re: [PATCH]460EX on-chip SATA driver<kernel 2.6.33><resubmission>

Dne Pá 4. června 2010 14:26:17 Rupjyoti Sarmah napsal(a):
> This patch enables the on-chip DWC SATA controller of the AppliedMicro
> processor 460EX.
>
> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com>
> Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>
>

--SNIP--

> +		dev_err(ap->dev, "%s: Command not pending cmd_issued=%d "
> +			"(tag=%d) DMA NOT started\n", __func__,
> +			hsdevp->cmd_issued[tag], tag);

Just a nitpick, but don't break strings if possible.
