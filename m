Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2IYXTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:19:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46064 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2IYXTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:19:15 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-f7-50623bf14140
Message-id: <50623BF1.9080907@samsung.com>
Date: Wed, 26 Sep 2012 08:19:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH Resend] extcon: Fix return value in
 extcon_register_interest()
References: <1348570879-24067-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1348570879-24067-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jQd2P1kkBBhc7jS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGlPvTmAseMFe8niTdwDiBuYuRk0NCwERi37ZnrBC2mMSFe+vZ
	uhi5OIQEpjNKzLu8nAXC6WKSmHusB6yDV0BL4vDvsywgNouAqsSVCyfA4mxA8f0vbgB1c3CI
	CkRI/OrngCgXlPgx+R5YuQhQycvu5UwgNrNAmcTGJbsZQWxhgRCJS19PgMWFBNwldv07BWZz
	CnhI7J+1mR2iXkdif+s0NghbXmLzmrfMExgFZiFZMQtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBIffM6kdjCsbLA4xCnAwKvHwNvxKDBBiTSwrrsw9xCjBwawkwmv8HCjE
	m5JYWZValB9fVJqTWnyIUZqDRUmcV/hTYICQQHpiSWp2ampBahFMlomDU6qBkblKxZpXZobb
	9zmsyhlR0pWzHlmluRSbbIqSSnk2udxlj0T7ezXjayv5rPoXnN/W7Pqh64nB8i0nGuZv0lz1
	f7pas/qk13JaoQqXMlLN+8oLZ83//Fb4/YEV15le5fFZ/65lnC57//v/p+d17m/PWZjvE3O/
	WHXW1epHj9Xylk9VOtzvwryBX4mlOCPRUIu5qDgRAKExmXE7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 08:01 PM, Sachin Kamat wrote:

> Propagate the value returned from extcon_find_cable_index()
> instead of -ENODEV. For readability, -EINVAL is returned in place of
> the variable.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---

Applied, thank you.

You can check it after some hours at below git repository for Extcon.
-
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Thanks,
Chanwoo Choi
