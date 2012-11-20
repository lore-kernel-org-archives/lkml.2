Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2KTHyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:54:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18401 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2KTHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:54:40 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d4-50ab373e6894
Message-id: <50AB3732.5050507@samsung.com>
Date: Tue, 20 Nov 2012 16:54:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Subject: Re: [PATCH 3/7] extcon: Fix return value in extcon-class.c
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
 <1353388963-23761-4-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353388963-23761-4-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zXV0789UBBl96pS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGygvH2QsesFSsPjGRtYHxL3MXIyeHhICJRHdjAyOELSZx4d56
	ti5GLg4hgWWMEiuv/4cren3mNytEYhGjxNcvZ5khnC4mia33P4G18wpoSVw6vYkdxGYRUJU4
	fe4tE4jNBhTf/+IG0FgODlGBCIlf/RwQ5YISPybfYwGxRYBKXnYvZwIpYRbwk5i4NwgkLCzg
	LNHx+gXU3lZGie+75rKBJDgFPCTuLpsLdhyzgI7E/tZpbBC2vMTmNW+ZIU4QkPg2+RALyEwJ
	AVmJTQfATpYQaGeXmD75EdTHkhIHV9xgmcAoNgvJSbOQjJ2FZOwCRuZVjKKpBckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGCExIb2DcVWDxSFGAQ5GJR7ehwmrAoRYE8uKK3MPMUpwMCuJ8DaVA4V4
	UxIrq1KL8uOLSnNSiw8x+gBdO5FZSjQ5HxiveSXxhsYGxoaGloZmppamBjiElcR5mz1SAoQE
	0hNLUrNTUwtSi2DGMXFwSjUwBu2fMa2lz5HFSjDq7ydz0RVfDPaWV052yyy8/f+BBnPlOXn1
	BflLJuk65JmeZFi7Q+NHu0LMipU7a38yT2v75fJGYHLBCW/GpSYbpBnStrhv9z8+7XGoQwXT
	EgsDBkU5iSgmBYct763XJkxXL9sdJVvue22j/3qe2klFonxXtq8x2GG/++MKJZbijERDLeai
	4kQAuzDxM7YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAV0789UBBleniFpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjJUXjrMXPGCpWH1iImsD
	41/mLkZODgkBE4nXZ36zQthiEhfurWfrYuTiEBJYxCjx9ctZZgini0li6/1PjCBVvAJaEpdO
	b2IHsVkEVCVOn3vLBGKzAcX3v7gB1M3BISoQIfGrnwOiXFDix+R7LCC2CFDJy+7lTCAlzAJ+
	EhP3BoGEhQWcJTpev2CFWNXKKPF911w2kASngIfE3WVzwQ5lFtCR2N86jQ3ClpfYvOYt8wRG
	gVlIVsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER90x6B+OqBotDjAIc
	jEo8vA8TVgUIsSaWFVfmHmKU4GBWEuFtKgcK8aYkVlalFuXHF5XmpBYfYvQBBsBEZinR5Hxg
	MsgriTc0NjEzsjQyMzYxNzbGIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgbHtrVDFgf/2
	lQ/6fT1VruxSz7b240h9emqN9U9Bg8lGb1J7NLNtj3M2SARNn//i1B3+xZNLIyQX/JCVKvg2
	15/Z+q76jfOaB9n+fBRQC3XUk+raNC32S0YU66rOEt9LnguTZ//58z34AoMmm31I/pKAZexP
	3uw4e1y374XigSnT7m/c+rpdSEGJpTgj0VCLuag4EQCkiKYO5QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 02:22 PM, Sachin Kamat wrote:
> Return the value obtained from the function extcon_register_interest
> instead of -EINVAL.
> 
> Silences the following warning:
> drivers/extcon/extcon-class.c:475 extcon_register_interest() info:
> why not propagate 'obj->cable_index' from extcon_find_cable_index()
> instead of -22?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---

I consolidate following two patches because of similar patch.

extcon: Fix return value in extcon-class.c
extcon: Redo: Fix return value in extcon_register_interest()

Thank you,
Chanwoo Choi
