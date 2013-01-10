Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab3AJBmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:42:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61599 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3AJBmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:42:10 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-4d-50ee1c714943
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tushar Behera'" <tushar.behera@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        patches@linaro.org
References: <1357287829-21701-1-git-send-email-tushar.behera@linaro.org>
 <CAJuYYwQx0hFQmkLaggd2NdA_xommXGPBDbhj1AuSH5YuASWA-w@mail.gmail.com>
 <50EA5A3E.7000806@linaro.org>
In-reply-to: <50EA5A3E.7000806@linaro.org>
Subject: RE: [PATCH] ARM: DTS: exynos4210-origen: Add MAX8997 node entry
Date: Wed, 09 Jan 2013 17:41:55 -0800
Message-id: <00e301cdeed3$ae2dce00$0a896a00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFPH86yQ3Zg+4nIJHy/f5W4MGSXLgGZVKIHAchPYquZJFpzsA==
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zQ91CmXcBBjPPsFhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUc3GlesIutYtrXDUwNjN2sXYycHBICJhJ/3zawQdhi
	EhfurQeyuTiEBJYxSpy/3coIUzThXzsjRGI6o8SCR1tZIJy/jBLNP2YygVSxCWhIHH7/jB3E
	FhGIk9h8cgk7SBEzSMe6Jdeg2tczSqyZdBKonYODU0BLYsmcWpAGYQEPie9/zjGD2CwCqhJf
	Z/4EG8QrYClxfOEjNghbUOLH5HssIDYzUOv6nceZIGx5ic1r3jJDnKogsePsa0aII5wkrl+e
	xQpRIy4x6cFDdoj5AhLfJh8CO0FCQFZi0wFmkNMkBFaxSyzr/wkNF0mJgytusExglJiFZPUs
	JKtnIVk9C8mKBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzFC4kxqB+PKBotDjAIcjEo8
	vJYz3wQIsSaWFVfmHmKU4GBWEuEN2f42QIg3JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPzgSkg
	ryTe0NjYxMzE1MTc0tTcFIewkjgv46knAUIC6YklqdmpqQWpRTDjmDg4pRoYuSUufjKtXL12
	82R1/f8HFjre6atboejo+fXez68yRraneDOjXL9I/248XpnStK4tLVv5YO+hdYnRcqcY/k5q
	95OKU/0Q6XRVWTV6/czrNfl7Pd5PeaVxaLGY8y+HbN8pettSHn6I3bdpp+7B9/xhZ130fj4J
	YWQ1WcKy7HDut+We158JVeeuVmIpzkg01GIuKk4EAGOxCHzgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd1CmXcBBh/nMVpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHNxpXrCLrWLa
	1w1MDYzdrF2MnBwSAiYSE/61M0LYYhIX7q1n62Lk4hASmM4oseDRVhYI5y+jRPOPmUwgVWwC
	GhKH3z9jB7FFBOIkNp9cwg5SxAzSsW7JNUaIjvWMEmsmnQRq5+DgFNCSWDKnFqRBWMBD4vuf
	c8wgNouAqsTXmT/BBvEKWEocX/iIDcIWlPgx+R4LiM0M1Lp+53EmCFteYvOat8wQpypI7Dj7
	mhHiCCeJ65dnsULUiEtMevCQfQKj0Cwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAiO4mdSOxhXNlgcYhTgYFTi4bWc+SZAiDWxrLgy9xCjBAezkghvyPa3AUK8
	KYmVValF+fFFpTmpxYcYfYA+ncgsJZqcD0wweSXxhsYmZkaWRmYWRibm5jiElcR5GU89CRAS
	SE8sSc1OTS1ILYIZx8TBKdXAOHHuYZaLqkUWoXsjXvbOM32RoDFJ7K2R+Y+Lmrtn8jDuaTnE
	8+NHheuR5/fXGfvfPcJ4pzlpWVrl0rLndgfOBz4RnDxTOazrPUPdrLo5EgbtH5YpMMr2vzU9
	ML+sOSo6UoajROfMk+7PLxllmc5l3xFIsyzUCOVQXWf++2Pcf8FnLEwuZ0+rKrEUZyQaajEX
	FScCALy5We8PAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera wrote:
> 
> On 01/04/2013 10:51 PM, Thomas Abraham wrote:
> > On 4 January 2013 00:23, Tushar Behera <tushar.behera@linaro.org> wrote:
> >> The node entry is added as per documentation and legacy board file.
> >>
> >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> >> ---
> >> The patch is rebased on v3.8-rc1.
> >>
> >>  arch/arm/boot/dts/exynos4210-origen.dts |  150
> +++++++++++++++++++++++++++++++
> >>  1 files changed, 150 insertions(+), 0 deletions(-)
> 
> Please ignore this patch.
> 
OK.

> >
> > This patch has already been posted. Here is the link:
> > https://patchwork.kernel.org/patch/1794501/
> >
> 
> Sorry, had missed that patch. I have added a 'Tested-by' to the original
> patch.
> 
OK, I will add 'Tested-by' when I apply that.

Thanks.

- Kukjin

