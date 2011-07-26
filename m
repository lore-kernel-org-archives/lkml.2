Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1GZSpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:45:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42775 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1GZSpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:45:13 -0400
Message-ID: <4E2F0B33.8070702@linux.vnet.ibm.com>
Date: Tue, 26 Jul 2011 14:45:07 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan.Morav@nuvoton.com
CC: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com,
        Leonid.Azriel@nuvoton.com, Guy.Pavlov@nuvoton.com
Subject: Re: [PATCH] TPM Nuvoton I2C driver, kernel 3.0
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com> <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com> <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com>
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 03:25 AM, Dan.Morav@nuvoton.com wrote:
> Hi,
>
> Below are the additions for WPCT301/NPCT501 Nuvoton Technology TPM with I2C interface device driver.
> This driver uses Linux I2C bus driver to interface with the I2C bus and Linux TPM driver (tpm.ko), to export the standard Linux TPM interface.
> This driver requires an I2C bus driver and TPM driver (tpm.ko) to be loaded prior to its loading.
> This driver tested on Linux kernel version 3.0-rc6 on an x86 based platform and Linux kernel version 2.6.36.3 on an ARM platform.
>
> Regards,
> Dan.
> ___
> +
> +static struct platform_driver ti2c_drv = {
> +       .driver = {
> +               .name = "tpm_ti2c",
> +               .owner = THIS_MODULE,
> +       },
> +    .suspend = tpm_ti2c_suspend,
> +    .resume = tpm_ti2c_resume,
indentation

    Stefan

