Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab2C2B4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:56:48 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:51087 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab2C2B4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:56:43 -0400
Message-ID: <4F73BD9F.7090301@toshiba.co.jp>
Date: Thu, 29 Mar 2012 10:40:47 +0900
From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20120322 Icedove/3.0.11
MIME-Version: 1.0
To: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org,
        stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, girish.shivananjappa@linaro.org,
        vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com,
        sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com,
        michaelc@cs.wisc.edu
Subject: Re: [PATCH v3 2/5] [SCSI] ufshcd: UFS UTP Transfer requests handling
References: <1330497714-26504-3-git-send-email-santoshsy@gmail.com> <4F6FF1E3.7080908@toshiba.co.jp> <CALMYJDvvY_7FpiVGuguK8i1C_n9ogJhrgsH+KerDc62Omn35aA@mail.gmail.com>
In-Reply-To: <CALMYJDvvY_7FpiVGuguK8i1C_n9ogJhrgsH+KerDc62Omn35aA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh Y wrote:
>> +               case READ_12:
>> +               case WRITE_12:
>
> Just a minor change, this will be READ_16 and WRITE_16.

Thanks. Your feedback will be correct.
