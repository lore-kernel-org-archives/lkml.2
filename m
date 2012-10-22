Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2JVBMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:12:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56825 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2JVBMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:12:45 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-d5-50849d8c7ed2
Message-id: <50849D8C.3070400@samsung.com>
Date: Mon, 22 Oct 2012 10:12:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: anish kumar <anish198519851985@gmail.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: trivial: kfree missed from remove path
References: <1350795539-13206-1-git-send-email-anish198519851985@gmail.com>
In-reply-to: <1350795539-13206-1-git-send-email-anish198519851985@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAd2euS0BBl+beS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrxuHWQq2slTs2bqYqYHxMnMXIyeHhICJRPOWWywQtpjEhXvr
	2boYuTiEBBYxSrQd388C4XQxSZw6/AWsg1dAS+LB7FlgNouAqsTxB72sIDYbUHz/ixtA3Rwc
	ogIREr/6OSDKBSV+TL7HAhIWEdCV2LQwBSTMDFQx6dVisL3CAs4Sr3e3gNlCAt4S227OYwIp
	5xTwkXi4kA2iXEdif+s0KFteYvOat8wTGAVmIVkwC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIEB98zqR2MKxssDjEKcDAq8fAyWTcHCLEmlhVX5h5ilOBgVhLhPRXfEiDE
	m5JYWZValB9fVJqTWnyIUZqDRUmct9kjJUBIID2xJDU7NbUgtQgmy8TBKdXAKOv1YsuMnXXp
	os9V/k+7H1h0PM5D+fYfE6Vrx6an63dc5qyd8frJrh9vrRS0HdS7VQ44OzOE7Y5kczz9WJVv
	a7K81FvVO32fEtp2rkiWurE5YJVRsIpvtpp7x9xW8VlvqllUqmN0a1yY7iQZdj4vl9U47hoY
	3vFi88VVRpm7k5oYJNKbHooosRRnJBpqMRcVJwIA/U7LBToCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 01:58 PM, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> Extcon core doesn't free the memory when we do unregister.
> Kfree is added in the remove path as it was missing.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/extcon/extcon-max77693.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
Applied, thanks.

You can check it after some hours at extcon tree:
- http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Chanwoo Choi
