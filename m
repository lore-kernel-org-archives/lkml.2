Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2JDBcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:32:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35597 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2JDBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:32:41 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-12-506ce7371781
Message-id: <506CE737.6010201@samsung.com>
Date: Thu, 04 Oct 2012 10:32:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] extcon: Fix kerneldoc for extcon_set_cable_state and
 extcon_set_cable_state_
References: <1349191833.14338.1.camel@phoenix>
In-reply-to: <1349191833.14338.1.camel@phoenix>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAV2L5zkBBj9mslhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mk38bmQv6eCoW/r3N3MD4m7OLkZNDQsBEYs+WeWwQtpjEhXvr
	gWwuDiGBRYwSs2+vZAFJCAl0MUn0XsoCsXkFtCQubegDa2ARUJU4t38mK4jNBhTf/+IGUJyD
	Q1QgQuJXPwdEuaDEj8n3wMaICChJrLp/GcxmFiiUWNR9lQnEFhZIlnj5bw07xCo9iYXNT1lA
	xnAK6Et8PysAUa4uMWneImYIW15i85q3zBMYBWYh2TALSdksJGULGJlXMYqmFiQXFCel5xrq
	FSfmFpfmpesl5+duYgQH3zOpHYwrGywOMQpwMCrx8Bp25wQIsSaWFVfmHmKU4GBWEuE13goU
	4k1JrKxKLcqPLyrNSS0+xCjNwaIkztvskRIgJJCeWJKanZpakFoEk2Xi4JRqYLQqDjFQOTpj
	15SYM2pzfs5V4Pgh9eXyxrl3l7pUH67Zuyjv7ZLma4Yx056oHq+cwNXoV/m6oePXSVON9/sv
	z6n+7FPDv+XcgzkXrT/ov1H5/1/i0CJtXZG160uSDr7bKSD78fv7Ndsjcw9ItlZWGDxyv2Rn
	J5P+emp7t5CeoPaUn4b7IuKz5IyUWIozEg21mIuKEwErbjO0OgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 12:30 AM, Axel Lin wrote:

> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/extcon/extcon-class.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 946a318..337bbb4 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -362,7 +362,7 @@ int extcon_get_cable_state(struct extcon_dev *edev, const char *cable_name)
>  EXPORT_SYMBOL_GPL(extcon_get_cable_state);
>  
>  /**
> - * extcon_get_cable_state_() - Set the status of a specific cable.
> + * extcon_set_cable_state_() - Set the status of a specific cable.
>   * @edev:	the extcon device that has the cable.
>   * @index:	cable index that can be retrieved by extcon_find_cable_index().
>   * @cable_state:	the new cable status. The default semantics is
> @@ -382,7 +382,7 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
>  EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
>  
>  /**
> - * extcon_get_cable_state() - Set the status of a specific cable.
> + * extcon_set_cable_state() - Set the status of a specific cable.
>   * @edev:	the extcon device that has the cable.
>   * @cable_name:	cable name.
>   * @cable_state:	the new cable status. The default semantics is


Applied, thanks.

I applied this patch at extcon git repository
and you can check it after some hours.
-
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Thank you,
Chanwoo Choi
