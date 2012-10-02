Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2JBA2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:28:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22073 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2JBA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:28:12 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-d5-506a351a3ba5
Message-id: <506A351A.4080009@samsung.com>
Date: Tue, 02 Oct 2012 09:28:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        anish kumar <anish.singh@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] extcon: adc-jack: Fix checking return value of
 request_any_context_irq
References: <1348788977.8055.1.camel@phoenix>
In-reply-to: <1348788977.8055.1.camel@phoenix>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAV0p06wAg8N7DC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGg79b2Qsms1T8f3mUuYFxO3MXIyeHhICJxPZpu9kgbDGJC/fW
	A9lcHEICixgl3s3cwALhdDFJrG57yghSxSugJXG6YScLiM0ioCrR1PkLrJsNKL7/xQ0gm4ND
	VCBC4lc/B0S5oMSPyffAykUElCRW3b8MNpNZYAajxKydp5lAEsICsRKNm8+AzRcS0JXYtesT
	M8gcTgE9if+9hSBhZgF1iUnzFjFD2PISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4AJ9J7WBc2WBxiFGAg1GJh3fnycwAIdbEsuLK3EOMEhzMSiK8
	nr+AQrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATSE0tSs1NTC1KLYLJMHJxSDYw1Kw4E
	lzx/Ej7/+oKq2vemf+esnHFr+tPMRHGZ4y2VD0XbubZs5TAUmnk6dmu9TUHmtuT3D+oeJc59
	qfDrhIhF5YPu/P7cLR8SUic937BzwcSfH/ya105cpqiyQLSs4zF357meO8pFR49sendKa8V1
	DV+PP1rz/Bzi9vld6Wy+q+6x/0/z7p5TSizFGYmGWsxFxYkAcYBBbzwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 08:36 AM, Axel Lin wrote:

> On failure, request_any_context_irq() returns a negative value.
> On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.
> 
> Also ensure adc_jack_probe() return 0 on success.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Applied, thanks.

I applied two patch from Axel Lin at extcon git-tree and
you can check it after some hours.
-
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Thank you,
Chanwoo Choi
