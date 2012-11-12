Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab2KLCYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:24:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16167 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2KLCYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:24:44 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-70-50a05deabe59
Message-id: <50A05DE9.8070907@samsung.com>
Date: Mon, 12 Nov 2012 11:24:41 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org,
        patches@linaro.org
Subject: Re: [PATCH 0/8] Fix coding style in sdhci.c
References: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
In-reply-to: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zXd1XsQsCDJb9l7C4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXMOf6IseAOe8W3G6ENjDPYuhg5OSQETCRe/OxlhLDF
	JC7cWw8U5+IQEljGKLFt/2ommKKtiw+zQySmM0psXTGdBcJ5ySjx78h+VpAqXgEtidkNh8DG
	sgioShxb2ARmswnoSGz/dhxoEgeHqECYxM7N6RDlghI/Jt9jAbFFgEoeLNoLZjMLJEq8X30a
	bKQw0OK9T3+xgLQKCXhIvPlZBxLmFPCU+NI/kRmiXEdif+s0NghbXmLzmrfMEBcISHybfAis
	VUJAVmLTAWaIV9rZJc73+kLYkhIHV9xgmcAoNgvJQbOQTJ2FZOoCRuZVjKKpBckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGCFxIbWDcWWDxSFGAQ5GJR5eycAFAUKsiWXFlbmHGCU4mJVEeKeJAIV4
	UxIrq1KL8uOLSnNSiw8x+gAdO5FZSjQ5HxizeSXxhsYGxoaGloZmppamBjiElcR5mz1SAoQE
	0hNLUrNTUwtSi2DGMXFwSjUwWp12kGAu4zzNtINJ6ov36YVTmDcwNqy/r7l8k7/ZhZf8STMX
	7ZhUYPTi+frddqITPlzz7b/bVxH6XG/Sn7u53yf2bDQNv62QxrzChqGSt5DZ9frj2UZ1V7Ta
	VMUD7fY3fu1+ctG/eNdZDufb4rL2B6aJvVBdJPdyZ8nrvjyTxj1+opcq6vLMlFiKMxINtZiL
	ihMBzeKkULgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQd1XsQsCDC6dF7a4vGsOm8WR//2M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmzDn+iLHgDnvF
	txuhDYwz2LoYOTkkBEwkti4+zA5hi0lcuLceKM7FISQwnVFi64rpLBDOS0aJf0f2s4JU8Qpo
	ScxuOATWzSKgKnFsYROYzSagI7H923GmLkYODlGBMImdm9MhygUlfky+xwJiiwCVPFi0F8xm
	FkiUeL/6NNhIYaAj9j79xQLSKiTgIfHmZx1ImFPAU+JL/0RmiHIdif2t09ggbHmJzWveMk9g
	FJiFZMMsJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcd8+kdjCubLA4xCjA
	wajEwysZuCBAiDWxrLgy9xCjBAezkgjvNBGgEG9KYmVValF+fFFpTmrxIUYfoP8nMkuJJucD
	U0JeSbyhsYmZkaWRmbGJubExDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYwnb3p9v6vJ
	PXOPMEf2v7+ORxSy2cwkDP/avz18q/eWn72S8ZI7gXMnh32Q1fnALLPkhpRo3LwfrXxWEz/+
	UC9/+bxn69Mrs7dkbd3HZCKqlpK1+uS7IBWbabHzX4psW8/gJ6HL+F6tPYX9XMu3/KV7i+u6
	j9zhEheOfme/XXk/U8xZCdnJq14qsRRnJBpqMRcVJwIAsgxOe+gCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

Could you make one patch? Why do you separate patches?

Best Regards,
Jaehoon Chung

On 11/09/2012 08:39 PM, Tushar Behera wrote:
> Documents/CodingStyle Chapter 3 recommends usage of braces for both
> if and else statements if any of the branches contains multiple
> statements.
> 
> Cleaning up drivers/mmc/host/sdhci.c for all these occurrences.
> 
> Tushar Behera (8):
>   mmc: sdhci: fix coding style in sdhci_calc_timeout
>   mmc: sdhci: fix coding style in sdhci_set_transfer_mode
>   mmc: sdhci: fix coding style in sdhci_finish_data
>   mmc: sdhci: fix coding style in sdhci_set_clock
>   mmc: sdhci: fix coding style in sdhci_do_set_ios
>   mmc: sdhci: fix coding style in sdhci_execute_tuning
>   mmc: sdhci: fix coding style in sdhci_data_irq
>   mmc: sdhci: fix coding style in sdhci_add_host
> 
>  drivers/mmc/host/sdhci.c |   58 +++++++++++++++++++++++++--------------------
>  1 files changed, 32 insertions(+), 26 deletions(-)
> 

