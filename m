Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2HAFId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 01:08:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29494 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2HAFIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 01:08:30 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-0e-5018b9cd5c17
From: Jingoo Han <jg1.han@samsung.com>
To: "'Damien Cassou'" <damien.cassou@lifl.fr>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: kernel-janitors@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
 <1343752762-16861-6-git-send-email-damien.cassou@lifl.fr>
 <002c01cd6f73$4252b090$c6f811b0$%han@samsung.com>
 <CAK9yfHzje6NLqi5ixxA3J4aT1a9p6wJNJePzTi4xG9LN6AeLVw@mail.gmail.com>
In-reply-to: <CAK9yfHzje6NLqi5ixxA3J4aT1a9p6wJNJePzTi4xG9LN6AeLVw@mail.gmail.com>
Subject: RE: [PATCH 5/5] drivers/video/exynos/exynos_dp_core.c: use devm_
 functions
Date: Wed, 01 Aug 2012 14:08:29 +0900
Message-id: <004201cd6fa3$b0538b70$10faa250$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1vmhyn5B4mG/inRTe3QdjosRjdBwACHyeQ
Content-language: ko
x-cr-hashedpuzzle: AqQ+ ItfL JnNa RxGB cqIq eO8M mBWh moto r4Ul socv yiBO 7XCL
 8xEl ABKXTQ== AByrqA==
 AB+d+g==;7;ZABhAG0AaQBlAG4ALgBjAGEAcwBzAG8AdQBAAGwAaQBmAGwALgBmAHIAOwBmAGwAbwByAGkAYQBuAHMAYwBoAGEAbgBkAGkAbgBhAHQAQABnAG0AeAAuAGQAZQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBrAGUAcgBuAGUAbAAtAGoAYQBuAGkAdABvAHIAcwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AZgBiAGQAZQB2AEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcwBhAGMAaABpAG4ALgBrAGEAbQBhAHQAQABsAGkAbgBhAHIAbwAuAG8AcgBnAA==;Sosha1_v1;7;{C22DAF9F-559A-468E-AFD6-39D2E3BC453A};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 01 Aug 2012 05:08:17
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADUALwA1AF0AIABkAHIAaQB2AGUAcgBzAC8AdgBpAGQAZQBvAC8AZQB4AHkAbgBvAHMALwBlAHgAeQBuAG8AcwBfAGQAcABfAGMAbwByAGUALgBjADoAIAB1AHMAZQAgAGQAZQB2AG0AXwAgAGYAdQBuAGMAdABpAG8AbgBzAA==
x-cr-puzzleid: {C22DAF9F-559A-468E-AFD6-39D2E3BC453A}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jAd2zOyUCDK6tkbHYekva4kTfB1aL
	y7vmsDkwe3zeJBfAGMVlk5Kak1mWWqRvl8CV8WbOa5aCVToVjw9sZW9gXCjfxcjJISFgInH1
	yBNWCFtM4sK99WxdjFwcQgKLGCWeHd8JlhAS+MUo0XXBH8RmE1CT+PLlMHsXIweHiEC4xOsr
	wiD1zAIHGCVeXGhlgmj+wyjRvLKbDaSBUyBYYnr/b3YQW1ggVGLanKnMIM0sAqoS3z5zgYR5
	BWwlTs+6ywRhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bsFYJAXWJR391QcIiAkYSszq3QpWL
	SOx78Y4R5AQJgRXsEhOP9LFAPGYqcWrTXeYJjCKzkKyYhWTFLCQrZiGZtYCRZRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcCw8k97BuKrB4hCjAAejEg/vCzOJACHWxLLiytxDjBIczEoi
	vGoRQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Jt5f/YUE0hNLUrNTUwtSi2CyTBycUg2Myjd7
	WkqyOaYk2QYt3xu33F9j+vOaPT+++SRIzg+ZvO9HyMz5ddq5h9r5yo+4GJX17zcxDNnSNmWd
	SYdR3+U3cUe1P5Su9o/84i5Uq8Bhl/NO/+Tn14bKes8vdFyML04/wHH2aEJkqVbBxQTDKVlL
	A5tUj0Tq++y4cPeaaVuP6uOuO3N2XKlTYinOSDTUYi4qTgQAg9/XaoECAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 01, 2012 1:00 PM Sachin Kamat wrote:
> 
> On 1 August 2012 04:51, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Wednesday, August 01, 2012 1:39 AM Damien Cassou wrote:
> >>
> >> From: Damien Cassou <damien.cassou@lifl.fr>
> >>
> >> The various devm_ functions allocate memory that is released when a driver
> >> detaches.  This patch uses these functions for data that is allocated in
> >> the probe function of a platform device and is only freed in the remove
> >> function.
> >>
> >> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>
> >>
> >> ---
> >>  drivers/video/exynos/exynos_dp_core.c |   27 +++++++--------------------
> >>  1 file changed, 7 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> >> index c6c016a..00fe4f0 100644
> >> --- a/drivers/video/exynos/exynos_dp_core.c
> >> +++ b/drivers/video/exynos/exynos_dp_core.c
> >> @@ -872,7 +872,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >>
> >>       dp->dev = &pdev->dev;
> >>
> >> -     dp->clock = clk_get(&pdev->dev, "dp");
> >> +     dp->clock = devm_clk_get(&pdev->dev, "dp");
> >>       if (IS_ERR(dp->clock)) {
> >>               dev_err(&pdev->dev, "failed to get clock\n");
> >>               return PTR_ERR(dp->clock);
> >> @@ -881,31 +881,24 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >>       clk_enable(dp->clock);
> >>
> >>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> -     if (!res) {
> >> -             dev_err(&pdev->dev, "failed to get registers\n");
> >> -             ret = -EINVAL;
> >> -             goto err_clock;
> >> -     }
> >
> > Why do you remove this return check?
> > If there is no reason, please, do it as follows:
> >
> >         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >         if (!res) {
> >                 dev_err(&pdev->dev, "failed to get registers\n");
> > -               ret = -EINVAL;
> > -               goto err_clock;
> > +               return -EINVAL;
> >         }
> >
> >
> 
> devm_request_and_ioremap function checks the validity of res. Hence
> this check above is redundant and can be removed.
> 
> Damien,
> This patch only adds devm_clk_get() function. Hence you could make the
> subject line more specific.

To Damien,
As Sachin Kamat mentioned, please change the subject more specific. For example,

    video: exynos_dp: use devm_clk_get function


Best regards,
Jingoo Han


> 
> 
> 
> 
> > Best regards,
> > Jingoo Han
> >
> >
> >>
> >>       dp->reg_base = devm_request_and_ioremap(&pdev->dev, res);
> >>       if (!dp->reg_base) {
> >>               dev_err(&pdev->dev, "failed to ioremap\n");
> >> -             ret = -ENOMEM;
> >> -             goto err_clock;
> >> +             return -ENOMEM;
> >>       }
> >>
> >>       dp->irq = platform_get_irq(pdev, 0);
> >>       if (!dp->irq) {
> >>               dev_err(&pdev->dev, "failed to get irq\n");
> >> -             ret = -ENODEV;
> >> -             goto err_clock;
> >> +             return -ENODEV;
> >>       }
> >>
> >>       ret = devm_request_irq(&pdev->dev, dp->irq, exynos_dp_irq_handler, 0,
> >>                               "exynos-dp", dp);
> >>       if (ret) {
> >>               dev_err(&pdev->dev, "failed to request irq\n");
> >> -             goto err_clock;
> >> +             return ret;
> >>       }
> >>
> >>       dp->video_info = pdata->video_info;
> >> @@ -917,7 +910,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >>       ret = exynos_dp_detect_hpd(dp);
> >>       if (ret) {
> >>               dev_err(&pdev->dev, "unable to detect hpd\n");
> >> -             goto err_clock;
> >> +             return ret;
> >>       }
> >>
> >>       exynos_dp_handle_edid(dp);
> >> @@ -926,7 +919,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >>                               dp->video_info->link_rate);
> >>       if (ret) {
> >>               dev_err(&pdev->dev, "unable to do link train\n");
> >> -             goto err_clock;
> >> +             return ret;
> >>       }
> >>
> >>       exynos_dp_enable_scramble(dp, 1);
> >> @@ -940,17 +933,12 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >>       ret = exynos_dp_config_video(dp, dp->video_info);
> >>       if (ret) {
> >>               dev_err(&pdev->dev, "unable to config video\n");
> >> -             goto err_clock;
> >> +             return ret;
> >>       }
> >>
> >>       platform_set_drvdata(pdev, dp);
> >>
> >>       return 0;
> >> -
> >> -err_clock:
> >> -     clk_put(dp->clock);
> >> -
> >> -     return ret;
> >>  }
> >>
> >>  static int __devexit exynos_dp_remove(struct platform_device *pdev)
> >> @@ -962,7 +950,6 @@ static int __devexit exynos_dp_remove(struct platform_device *pdev)
> >>               pdata->phy_exit();
> >>
> >>       clk_disable(dp->clock);
> >> -     clk_put(dp->clock);
> >>
> >>       return 0;
> >>  }
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> --
> With warm regards,
> Sachin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

