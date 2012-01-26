Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2AZHj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 02:39:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48523 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2AZHjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 02:39:55 -0500
MIME-Version: 1.0
In-Reply-To: <000001ccdbfb$926d90b0$b748b210$%jun@samsung.com>
References: <002701ccd728$edab9350$c902b9f0$%jun@samsung.com>
	<CAKLKtzddDXhbT6o8XUsMxad9+_a_StJCQz+eBnfQ+q+xLuJQKg@mail.gmail.com>
	<CAKYAXd8A70X1gb-NFHVDMXd-aSG6+Y3PWvRTZDMT3-Ze3aF5Yw@mail.gmail.com>
	<002501ccdb20$c98b2e80$5ca18b80$%jun@samsung.com>
	<CAKYAXd_jdGfpC9kcYht=qnfaTPwE+YEx1fo89GkpRyWcN6igig@mail.gmail.com>
	<CAKYAXd-pCS4kRsg0PJp98YRqz_P0CtTKWEWiQJarE_iHqiesYQ@mail.gmail.com>
	<000c01ccdbf0$71fe58b0$55fb0a10$%jun@samsung.com>
	<CAKYAXd8zFf7AF5_X-divH51+B=Y2YC1ZjZF00D_=+R6eF8qe9g@mail.gmail.com>
	<000001ccdbfb$926d90b0$b748b210$%jun@samsung.com>
Date: Thu, 26 Jan 2012 16:39:53 +0900
Message-ID: <CAKYAXd8mKNGk2e8wo1eG9zB0L876HswMO4JmxAJ85TkouaB1UA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mmc: core: Support packed command for eMMC4.5 device
From: Namjae Jeon <linkinjeon@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Saugata Das <saugata.das@linaro.org>, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >        - Add a variable member in mmc_host for minimum number of packed entries.
>> >          This value can be overridden by host.
>> Ah.. Okay~ I clearly understand about two queston.
>> Totally, Looks good to me.
>> Thanks for your reply.
>> And I heard that packed cmd is not good while reading small chunk,
>> If so, I want to use packed write cmd not read cmd.
>> Can I use packed only packed write cmd by seperating
>> MMC_CAP2_PACKED_READ_CMD and MMC_CAP2_PACKED_WRITE_CMD ?
> Do you think this separate use is common?
> Let me consider this more.
It is just my idea on user side. if we can select packed read/write
set, I believe that we can optmize performance accoding to own's
environment.
Thanks.
