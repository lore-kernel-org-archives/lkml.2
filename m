Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2LJBfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:35:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12992 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2LJBfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:35:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-13-50c53c6e505e
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, thomas.abraham@linaro.org,
        patches@linaro.org
References: <1354702655-26388-1-git-send-email-sachin.kamat@linaro.org>
 <CACRpkdaEdGLj4CuZa3tyCBhQBBTxtwS4c1D4aYJ6kGaiHJ0YUw@mail.gmail.com>
In-reply-to: <CACRpkdaEdGLj4CuZa3tyCBhQBBTxtwS4c1D4aYJ6kGaiHJ0YUw@mail.gmail.com>
Subject: RE: [PATCH 1/1] pinctrl: samsung: Fix a typo in pinctrl-samsung.h
Date: Mon, 10 Dec 2012 10:35:42 +0900
Message-id: <031d01cdd676$aac42a40$004c7ec0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3T74XbXLY1mZ6kRk2e2Cx/YsZCIQChlkdQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zfd08m6MBBvMfSVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MmVcuMRacYKm4vm8iSwPjJeYuRk4OCQETict/vkHZYhIX7q1n
	62Lk4hASWMYo8ebvfiaYovt3v7GD2EICixglpk/mhSiaxyRx6uBXNpAEm4CGxOH3z8CKRASi
	JNo/rmYFsZkF/CXmnf3NDNHQBzT10V2gBAcHp0CwxNw1miA1wgJeEtNmHmcEsVkEVCVurN8O
	NpNXwFbi2tWjTBC2oMSPyfdYIGZqSWze1gQ1X15i85q3zCAjJQTUJR791YU4wUhi8oRZTBAl
	IhL7XryDGi8g8W3yIRaIclmJTQfALpMQWMQucfTLCUaIfyUlDq64wTKBUWIWks2zkGyehWTz
	LCQrFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIiSzpHYyrGiwOMQpwMCrx8AYoHg0Q
	Yk0sK67MPcQowcGsJMLLdexIgBBvSmJlVWpRfnxRaU5q8SFGH6DLJzJLiSbnA6M+ryTe0NjY
	xMzE1MTc0tTcFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbG5Iobbz7IdJa8u/PKMs9t
	5cU1m857/f7n+edGO9NqwanBmxNNf8zizT8w2eHt9HArDtWLh1JD8xgOB+zbcMx6enmN5Bf2
	yUVzEp+3WUxYJqd2Zq0o2zHulH0rfdn2xWu4HL2zwuv2+9OzTr2Py3f0vuOwaPGjpzNFqw4f
	2dyheC245pqLhVDNdSWW4oxEQy3mouJEAIeBu2bZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd08m6MBBs3zxC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxswrlxgLTrBUXN83kaWB
	8RJzFyMnh4SAicT9u9/YIWwxiQv31rOB2EICixglpk/m7WLkArLnMUmcOvgVLMEmoCFx+P0z
	sAYRgSiJ9o+rWUFsZgF/iXlnfzNDNPQxSrx5dBcowcHBKRAsMXeNJkiNsICXxLSZxxlBbBYB
	VYkb67eDzeQVsJW4dvUoE4QtKPFj8j0WiJlaEpu3NUHNl5fYvOYtM8hICQF1iUd/dSFOMJKY
	PGEWE0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOC4fSa9g3FVg8UhRgEORiUe3gDFowFCrIllxZW5hxglOJiVRHi5jh0JEOJNSaysSi3K
	jy8qzUktPsToA/ToRGYp0eR8YErJK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JESICSQnliSmp2a
	WpBaBDOOiYNTqoEx4N3/ZeHt51Zdfrxn0WrLB+tnrQs3/Xh627QlB7/N2tsqO3uhRuLy69sL
	5BMt7OSMz52cO0fipWuIw45jWSq8ckoVM58o+t1fnqz6J1WTfcKKG5uWMl5JvMpV7RU979q+
	lsZXOcdkuyZYCpTJqbp2e+tFzku6ZXtp8Uprs9T0Y5f+Kry2eBmZoMRSnJFoqMVcVJwIAB29
	BDYIAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Wed, Dec 5, 2012 at 11:17 AM, Sachin Kamat <sachin.kamat@linaro.org>
> wrote:
> 
> > struct samsung_pin_bank does not have a member called reg_offset.
> > It should be pctl_offset instead.
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Kukjin, art you taking this patch?
> 
I did just now with your ack :-)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

