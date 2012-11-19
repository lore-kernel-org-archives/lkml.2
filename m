Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2KSB3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 20:29:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11935 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KSB3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 20:29:13 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-bd-50a98b676528
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Tushar Behera'" <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
 <1353048646-10935-7-git-send-email-tushar.behera@linaro.org>
 <CACRpkdZ5EyiKrUDNaa4Rkn_cbJF1yD91CcpNfwxNXAd58FP8Aw@mail.gmail.com>
In-reply-to: <CACRpkdZ5EyiKrUDNaa4Rkn_cbJF1yD91CcpNfwxNXAd58FP8Aw@mail.gmail.com>
Subject: RE: [PATCH 06/14] pinctrl: samsung: Update error check for unsigned
 variables
Date: Mon, 19 Nov 2012 10:29:11 +0900
Message-id: <098801cdc5f5$4732e6b0$d598b410$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3FApofhAelCQSpRLShxrSrrECS9gA7oC/g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zQ9307pUBBjMOaVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtyfWsRac5K6YfCG4gfE/RxcjB4eEgIlEz73gLkZOIFNM4sK9
	9WxdjFwcQgLLGCU+9XYxQSRMJKZe2scOkZjOKLHr/1uwhJDAPCaJLROSQWw2AQ2Jw++fsYPY
	IgIxEv/vT2IDWcAM1Lx5fh5E7zlGidN7usBqOAWCJSYeW8YIYgsLREjMmvKTDcRmEVCVuL91
	A9h8XgFbibOnT0LZghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeIZdYlHf3VBTBEBI4lLuywg
	KkQk9r14xwgxXUDi2+RDLBDVshKbDjCDXCYhsIhd4tHWj+wQ70pKHFxxg2UCo8QsJItnIVk8
	C8niWUhWLGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRElNSOxhXNlgcYhTgYFTi4XXo
	XBkgxJpYVlyZe4hRgoNZSYRX0xIoxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnAeM8riTc0
	NjYxMzE1Mbc0NTfFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgXHPnMq9Ka972kudxDQk
	9t+fbeG4MX5ZhbrVi1M7yrIMlpxnTc2+mSPgobju0+6jtfrtD3l2bNB3aI26qeaRanHM+Xl9
	5oNthYs+hyzlu39j7XWWXUx8RrHWMzoFn7DfKsjbOPurmEK2/c3sjZvX3/m/88FGiyfn/2+K
	d36+XJDFZ/nNd+uepvkqsRRnJBpqMRcVJwIAU9jtD9YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd307pUBBtOaVS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtsT61gLTnJXTL4Q3MD4
	n6OLkZNDQsBEYuqlfewQtpjEhXvr2boYuTiEBKYzSuz6/5YJJCEkMI9JYsuEZBCbTUBD4vD7
	Z2ANIgIxEv/vTwJq4OBgBhq0eX4eRO85RonTe7rAajgFgiUmHlvGCGILC0RIzJrykw3EZhFQ
	lbi/dQPYfF4BW4mzp09C2YISPybfYwGxmQW0JNbvPM4EYctLbF7zlhlkl4SAusSjv7ogpoiA
	kcSlXRYQFSIS+168Y5zAKDQLyaBZSAbNQjJoFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGCY/aZ1A7GlQ0WhxgFOBiVeHgdOlcGCLEmlhVX5h5ilOBgVhLh1bQECvGmJFZWpRbl
	xxeV5qQWH2L0AfpzIrOUaHI+MJ3klcQbGpuYGVkamVkYmZib4xBWEudt9kgJEBJITyxJzU5N
	LUgtghnHxMEp1cBoEjq/bmrPxjM+F+7rTVn4uJ2/PSjzouTst36hM0r7z3Iy+twR9wri+cPR
	8+uLxmeHnwFHzzwQeLbj7mr16tBdFhPMeX8/TL0rIXrwh9qmO8EB2hq6j97Gbglf/aaVXzBK
	8Fz+en4uRhPNj983Vm11m5uT9SBfosXIMOzSzx6vu2uYYr3lrlkosRRnJBpqMRcVJwIAKyRt
	HgYDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Fri, Nov 16, 2012 at 7:50 AM, Tushar Behera <tushar.behera@linaro.org>
> wrote:
> 
> > Checking '< 0' for unsigned variables always returns false. For error
> > codes, use IS_ERR_VALUE() instead.
> >
> > CC: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > ---
> >  drivers/pinctrl/pinctrl-samsung.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/pinctrl/pinctrl-samsung.c
> b/drivers/pinctrl/pinctrl-samsung.c
> > index 81c9896..3b52c17 100644
> > --- a/drivers/pinctrl/pinctrl-samsung.c
> > +++ b/drivers/pinctrl/pinctrl-samsung.c
> > @@ -560,7 +560,7 @@ static int __devinit
> samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
> >         const char *pin_name;
> >
> >         *npins = of_property_count_strings(cfg_np, "samsung,pins");
> > -       if (*npins < 0) {
> > +       if (IS_ERR_VALUE(*npins)) {
> >                 dev_err(dev, "invalid pin list in %s node",
cfg_np->name);
> >                 return -EINVAL;
> >         }
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> For this merge window Kukjin is handling the Samsung pinctrl patches,
> Kukjin can you pick this to your tree to avoid any mess?
> 
Sure, I will.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

