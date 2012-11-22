Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2KVSxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:53:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26512 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2KVSx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:53:28 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-67-50ad751a1f57
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: jonghwa3.lee@samsung.com, "'Kyungmin Park'" <kmpark@infradead.org>
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <007401cdc6ba$0742d6d0$15c88470$%choi@samsung.com>
 <CAH9JG2VKYSAQ=Og4-fgToV_aNwEV_aH-=UQZDbAOnA-ShfKdYw@mail.gmail.com>
 <50AC5250.3070203@samsung.com>
In-reply-to: <50AC5250.3070203@samsung.com>
Subject: RE: [PATCH v3 2/2] therma: exynos: Supports thermal tripping
Date: Thu, 22 Nov 2012 09:43:01 +0900
Message-id: <000701cdc84a$5602eda0$0208c8e0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HnQO7minC9LIaTJiUO73Q4BzVhgAq/H7w
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zA12p0rUBBhv381pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MF/O/sBQcMahY+OMBUwPjG+UuRg4OCQETibaj1l2MnECmmMSF
	e+vZuhi5OIQEljFKLH3/nRUiYSJxrq+dFSIxnVHi96x5UFXzmCT6Nt0Fq2IT0JU4tn4LmC0i
	4CLx7uYXZpAiZoENjBJr7n1CmPth4VQ2kCpOAW2JGy/OMYLYwgKuEnOunWECsVkEVCX+Lf8K
	ZvMK2Em8ePCfBcIWlPgx+R6YzSygLjFp3iJmCFtb4sm7C6wQ/6hLPPqrC3GEkcTnnYegykUk
	9r14xwgxXkDi22SQOEi5rMSmA8wQXy5il+g+nQhhS0ocXHGDZQKjxCwki2chWTwLyeJZSDYs
	YGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESW1I7GFc2WBxiFOBgVOLh1XReGyDEmlhW
	XJl7iFGCg1lJhHdRAVCINyWxsiq1KD++qDQntfgQow/Q4ROZpUST84Fxn1cSb2hsbGJmYmpi
	bmlqbopDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QD44af7wQPJ/D/FiozYg3gsntmc9Tz
	X9jpqmLetykrVGYHBWvsbbta2/5c5HdRjuOL5QV8E3Y4GCi/dPOucc5f4dreeOzTg8kiu5eJ
	7W9wm3kj+yL7x2nmT3Id31WWqB1L14pILTBf4Cw56Xe4ybmKd3lCtityJhyvD485OZFhwYE1
	3ieUr2vdVGIpzkg01GIuKk4EAH93/iXaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV2p0rUBBucvcVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjBfzv7AUHDGoWPjjAVMD
	4xvlLkZODgkBE4lzfe2sELaYxIV769m6GLk4hASmM0r8njUPypnHJNG36S5YFZuArsSx9VvA
	bBEBF4l3N78wgxQxC2xglFhz7xNUxzJGiQ8Lp7KBVHEKaEvceHGOEcQWFnCVmHPtDBOIzSKg
	KvFv+Vcwm1fATuLFg/8sELagxI/J98BsZgF1iUnzFjFD2NoST95dANrMAXSrusSjv7oQRxhJ
	fN55CKpcRGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5y
	fu4mRnD0PpPawbiyweIQowAHoxIPr6bz2gAh1sSy4srcQ4wSHMxKIryLCoBCvCmJlVWpRfnx
	RaU5qcWHGH2AHp3ILCWanA9MLHkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1KzU1ML
	UotgxjFxcEo1MHo9VLgb4Xjt2fN1G8/nM3E7rxJ7xMv3UMfacevctcfXTvPnTb7KO0k80vTi
	U7NSZr8tp6KFKl6k2srFCVkVXX68vzI85x/X3i8BJhmb1qyceuaJ3wP/nAWxkn4nf6ad6/+o
	pnnR47zPUa4FET+37PgYlvREoCxs9xzfarltazd1b91jknF6bbsSS3FGoqEWc1FxIgBoRyUY
	CwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi~


> >>                                 data->base + EXYNOS_THD_TEMP_RISE);
> >> @@ -665,6 +672,8 @@ static void exynos_tmu_control(struct
> platform_device
> >> *pdev, bool on)
> >>                 con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
> >>                 con |= pdata->noise_cancel_mode <<
> >> EXYNOS_TMU_TRIP_MODE_SHIFT;
> >>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
> >> +               if (pdata->trigger_levels[3])
> >> +                       con |= EXYNOS_TMU_TRIP_EN;
> >>         }
> Why don't you support trigger_level[3] in exynos4210 either? Even though
> 4210 doesn't support
> hardware tripping,
> I think it can be set in same way. I've done it in my local git with
> following codes.
> 

As follows, TRIP_EN is applied SOC_ARCH_EXYNOS(for exynos4412 & exynos5250).  (SOC_ARCH_EXYNOS4210 for exynos4210)

        if (data->soc == SOC_ARCH_EXYNOS) {
                con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
                con |= pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT;
                con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
                if (pdata->trigger_levels[3])
                        con |= EXYNOS_TMU_TRIP_EN;
        }
And. Trigger_level3_en is not stored in INTEN(only level0~level2en)

Especially when temperature exceeds a extremely high threshold temperature
denoted as THRES_LEVEL_RISE3 field of THRESHOLD_TEMP_RISE register, then
Exynos5250 should not be damaged by the hot temperature. In this case, TMU
urgently sends active-high signal (THERM_TRIP) to PMU, and thermal tripping
by hardware logic i.e PMU (Power Management Unit) is performed. (From TMU document.) 

Trigger_leves[3] is only used for THERM_TRIP. Trigger_levels3_en doesn't  effect h/w tripping mode.
So i think trigger_levels[3] is better than trigger_level3_en.

Thanks~~^^



> -----Original Message-----
> From: jonghwa3.lee@samsung.com [mailto:jonghwa3.lee@samsung.com]
> Sent: Wednesday, November 21, 2012 1:02 PM
> To: Kyungmin Park
> Cc: Jonghwan Choi; jonghwa3.lee; open list; Amit Daniel Kachhap; Zhang Rui;
> Sachin Kamat
> Subject: Re: [PATCH v3 2/2] therma: exynos: Supports thermal tripping
> 
> Hi,
> On 2012년 11월 20일 10:40, Kyungmin Park wrote:
> > On 11/20/12, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> >> TMU urgently sends active-high signal (thermal trip) to PMU,
> >> and thermal tripping by hardware logic i.e PMU is performed.
> >> Thermal tripping means that PMU cut off the whole power of SoC
> >> by controlling external voltage regulator.
> >>
> >> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> > Ackedy-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >>  drivers/thermal/exynos_thermal.c |   10 ++++++++++
> >>  1 files changed, 10 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/thermal/exynos_thermal.c
> >> b/drivers/thermal/exynos_thermal.c
> >> index 129e827..569478d 100644
> >> --- a/drivers/thermal/exynos_thermal.c
> >> +++ b/drivers/thermal/exynos_thermal.c
> >> @@ -58,6 +58,7 @@
> >>  #define EXYNOS_TMU_CORE_ON             BIT(0)
> >>  #define EXYNOS_TMU_CORE_ON_SHIFT       0
> >>  #define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
> >> EXYNOS_TMU_CORE_ON_SHIFT)
> >> +#define EXYNOS_TMU_TRIP_EN             BIT(12)
> >>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
> >>
> >>  /* Exynos4210 specific registers */
> >> @@ -631,6 +632,12 @@ static int exynos_tmu_initialize(struct
> >> platform_device
> >> *pdev)
> >>                         goto out;
> >>                 }
> >>                 rising_threshold |= (threshold_code << 16);
> >> +               threshold_code = temp_to_code(data,
> >> pdata->trigger_levels[3]);
> >> +               if (threshold_code < 0) {
> >> +                       ret = threshold_code;
> >> +                       goto out;
> >> +               }
> >> +               rising_threshold |= (threshold_code << 24);
> >>
> >>                 writel(rising_threshold,
> >>                                 data->base + EXYNOS_THD_TEMP_RISE);
> >> @@ -665,6 +672,8 @@ static void exynos_tmu_control(struct
> platform_device
> >> *pdev, bool on)
> >>                 con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
> >>                 con |= pdata->noise_cancel_mode <<
> >> EXYNOS_TMU_TRIP_MODE_SHIFT;
> >>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
> >> +               if (pdata->trigger_levels[3])
> >> +                       con |= EXYNOS_TMU_TRIP_EN;
> >>         }
> Why don't you support trigger_level[3] in exynos4210 either? Even though
> 4210 doesn't support
> hardware tripping,
> I think it can be set in same way. I've done it in my local git with
> following codes.
> 
> if (data->soc == SOC_ARCH_EXYNOS4210)
> interrupt_en |= pdata->trigger_level3_en << 12;
> else
> con |= pdata->trigger_level3_en <<12;
> 
> How do you think of it?
> 
> Thanks.
> >>         if (on) {
> >> @@ -770,6 +779,7 @@ static struct exynos_tmu_platform_data const
> >> exynos_default_tmu_data = {
> >>         .trigger_levels[0] = 85,
> >>         .trigger_levels[1] = 103,
> >>         .trigger_levels[2] = 110,
> >> +       .trigger_levels[3] = 120,
> >>         .trigger_level0_en = 1,
> >>         .trigger_level1_en = 1,
> >>         .trigger_level2_en = 1,
> >> --
> >> 1.7.4.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

