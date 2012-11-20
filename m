Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2KTHyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:54:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39173 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTHyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:54:31 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a7-50ab3736bea2
Message-id: <50AB372B.4010104@samsung.com>
Date: Tue, 20 Nov 2012 16:54:19 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Subject: Re: [PATCH 0/7] extcon: Fixes and code updates
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t8zXV0z89UBBi8ey1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MWR+PsBVcY69Yvv86WwPjUrYuRk4OCQETiaVvH7JC2GISF+6t
	B4pzcQgJLGOU+L71B1zR9I1nmSAS0xklWu99YIFwupgkVrY1gbXzCmhJrFs8iR3EZhFQlXj9
	9hcTiM0GFN//4gbQJA4OUYEIiV/9HBDlghI/Jt9jAbFFgEpedi9nAilhFvCTmLg3CCQsLGAu
	cXTTSrASIQF3ic437WBTOAU8JOa8cAcJMwvoSOxvncYGYctLbF7zlhniAAGJb5MPsYCUSwjI
	Smw6wAxysITAfzaJE/tOQ/0rKXFwxQ2WCYxis5AcNAvJ2FlIxi5gZF7FKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERIP0jsYVzVYHGIU4GBU4uF9mLAqQIg1say4MvcQowQHs5IIb1M5UIg3
	JbGyKrUoP76oNCe1+BCjD9C1E5mlRJPzgbGaVxJvaGxgbGhoaWhmamlqgENYSZy32SMlQEgg
	PbEkNTs1tSC1CGYcEwenVAPjJK44w+fnXneJH1wb8Ln6zWU9L96bhnfNrkxPLi2aFbD+tbmB
	XOYxxXXz5h61btSOvvJBTijLXnPDVydx/20rH/+L/XNkqYNf0R7r7ofy4SVaCydseJN3K/3n
	fFn7mQ3bfmRyfk7n31PufiNfMnSmKVdxguOflKudf8ymx84/t9e/fe30tMBeJZbijERDLeai
	4kQAJyFv3LQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQV0z89UBBv3TxSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqyPR9gKrrFXLN9/na2B
	cSlbFyMnh4SAicT0jWeZIGwxiQv31gPFuTiEBKYzSrTe+8AC4XQxSaxsa2IFqeIV0JJYt3gS
	O4jNIqAq8frtL7BuNqD4/hc3gLo5OEQFIiR+9XNAlAtK/Jh8jwXEFgEqedm9nAmkhFnAT2Li
	3iCQsLCAucTRTSvBSoQE3CU637SDTeEU8JCY88IdJMwsoCOxv3UaG4QtL7F5zVvmCYwCs5As
	mIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqPtmfQOxlUNFocYBTgYlXh4
	HyasChBiTSwrrsw9xCjBwawkwttUDhTiTUmsrEotyo8vKs1JLT7E6AP0/kRmKdHkfGAiyCuJ
	NzQ2MTOyNDIzNjE3NsYhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0XTxQUfPit1rtnT+
	aVRTlor0mWjoN7Os7lyXU0vph5qVkxe5umWfSTrpsk9Wl1Hz6zrezb3Ju9zuX7K4oWW/6tjx
	lat13wvu/K38gO3qxuC2ExFfTKcoLi3wO37IyJ//130FnWNHrwWHVvAeeZebv9eYK+piAeMt
	33nXVHjmNd2qtAmVL3ryXYmlOCPRUIu5qDgRAJvTNJDjAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 02:22 PM, Sachin Kamat wrote:
> This series is build tested and based on linux-next (20121115) and extcon
> tree at git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git
> 
> Sachin Kamat (7):
>   extcon: max8997: Fix checkpatch error
>   extcon: max8997: Fix a typo
>   extcon: Fix return value in extcon-class.c
>   extcon: max8997: Fix incorrect error check and return value
>   extcon: max77693: Fix incorrect error check and return value
>   extcon: max8997: Use devm_kzalloc
>   extcon: max77693: Use devm_kzalloc
> 
>  drivers/extcon/extcon-class.c    |    2 +-
>  drivers/extcon/extcon-max77693.c |   33 ++++++++++++++-------------------
>  drivers/extcon/extcon-max8997.c  |   28 ++++++++++++----------------
>  3 files changed, 27 insertions(+), 36 deletions(-)
> 
Applied, thanks.

You can check this patch on extcon tree:
- git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git (for-next branch)

Chanwoo Choi
