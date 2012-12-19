Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2LSDic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 22:38:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38864 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LSDiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 22:38:24 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a9-50d136af8d69
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355501608-2955-1-git-send-email-tobetter@gmail.com>
 <CAJuYYwS-+x9=V5z+POGYCHL8TkUDjrRB663Mys6ppCBXRASxFQ@mail.gmail.com>
In-reply-to: <CAJuYYwS-+x9=V5z+POGYCHL8TkUDjrRB663Mys6ppCBXRASxFQ@mail.gmail.com>
Subject: RE: [PATCH] ARM: EXYNOS: Fix MSHC clocks instance names
Date: Tue, 18 Dec 2012 19:38:20 -0800
Message-id: <002101cddd9a$4bd206d0$e3761470$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLuflk97Z6jIKdl+PnKMAj17t3dEgKiYkEUlckiW9A=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zfd31ZhcDDGZukbG4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo49XwjS8Em3or1N5tZGxjXcXQxcnJICJhIvG5fywRh
	i0lcuLeerYuRi0NIYBmjxImP8xhhilq3fWeGSCxilPg0+zY7hPOXUeLn9Ytg7WwCGhKH3z9j
	B7FFBMIkVvx4zQhSxCwwjVHizc8+qPYORonr6y+wgVRxCgRLPN9/AKxbWMBBYsXplWDdLAKq
	Em1LHrCA2LwClhJvOyE28AoISvyYfA8sziygJbF5WxMrhC0vsXnNW2aIWxUkdpwF2cwBdIWV
	RPuxIogScYlJDx5CjReQ+Db5EAtIiYSArMSmA2CnSQisYpeYv2cZNCwkJQ6uuMEygVFiFpLN
	s5BsnoVk8ywkKxYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECIk06R2MqxosDjEKcDAq
	8fBKrrgQIMSaWFZcmXuIUYKDWUmEl1f1YoAQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wOT
	QF5JvKGxsYmZiamJuaWpuSkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjKbphu9TVMvX
	svmu6PZnC08JW35Ce5G0//Ptr9vuvebYxzOl+ldE3ou9QbZ7AuXq28P2HlFc2XVJy0oy612I
	nzJnVcyBRpZr2nX/i296TvCOjdxkKenVFpfhvO3c1qruo/tkYhgNK8+u4X51L2dL9yU3uZig
	dPHve/efmqviVO6yasGE27a6SizFGYmGWsxFxYkAljpkueECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd31ZhcDDNb+Ere4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOPV8I0vBJt6K
	9TebWRsY13F0MXJySAiYSLRu+84MYYtJXLi3nq2LkYtDSGARo8Sn2bfZIZy/jBI/r19kAqli
	E9CQOPz+GTuILSIQJrHix2tGkCJmgWmMEm9+9jFDdHQwSlxff4ENpIpTIFji+f4DYN3CAg4S
	K06vBOtmEVCVaFvygAXE5hWwlHjbCbGBV0BQ4sfke2BxZgEtic3bmlghbHmJzWveQt2qILHj
	LMhmDqArrCTajxVBlIhLTHrwkH0Co9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIjuNn0jsYVzVYHGIU4GBU4uGVXHEhQIg1say4MvcQowQHs5IIL6/qxQAh
	3pTEyqrUovz4otKc1OJDjD5Aj05klhJNzgemmLySeENjEzMjSyMzCyMTc3McwkrivM0eKQFC
	AumJJanZqakFqUUw45g4OKUaGGu863P2nnLmf+Fpdb2f2XbNYVfXX/9+3mWXV/p9WDrv3PYU
	Ru8dsUEKqv7JAafmbbysuqk1PnEf994TD2atUrXbPDtdpc98wvPKQx3idvPsNGudI0qSN5Xe
	eRTPUnysVSGy/+vJ3TGzH69dXzjtnULFEuuu+fcOGM1SvLzpp46gJUPHo20TOJVYijMSDbWY
	i4oTAfCw0HsQAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> On 14 December 2012 21:43, Dongjin Kim <tobetter@gmail.com> wrote:
> > Replace clock instance name of MSHC controller for BIC and CIU of
> Exynos4412.
> >
> > Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> > ---
> >  arch/arm/mach-exynos/clock-exynos4.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/clock-exynos4.c b/arch/arm/mach-
> exynos/clock-exynos4.c
> > index efead60..bbcb3de 100644
> > --- a/arch/arm/mach-exynos/clock-exynos4.c
> > +++ b/arch/arm/mach-exynos/clock-exynos4.c
> > @@ -529,7 +529,7 @@ static struct clk exynos4_init_clocks_off[] = {
> >                 .enable         = exynos4_clk_ip_fsys_ctrl,
> >                 .ctrlbit        = (1 << 8),
> >         }, {
> > -               .name           = "dwmmc",
> > +               .name           = "biu",
> >                 .parent         = &exynos4_clk_aclk_133.clk,
> >                 .enable         = exynos4_clk_ip_fsys_ctrl,
> >                 .ctrlbit        = (1 << 9),
> > @@ -1134,7 +1134,7 @@ static struct clksrc_clk exynos4_clksrcs[] = {
> >                 .reg_div = { .reg = EXYNOS4_CLKDIV_MFC, .shift = 0,
.size = 4 },
> >         }, {
> >                 .clk    = {
> > -                       .name           = "sclk_dwmmc",
> > +                       .name           = "ciu",
> >                         .parent         = &exynos4_clk_dout_mmc4.clk,
> >                         .enable         = exynos4_clksrc_mask_fsys_ctrl,
> >                         .ctrlbit        = (1 << 16),
> > --
> 
> Acked-by: Thomas Abraham <thomas.abraham@linaro.org>
> 
Thanks, applied.

- Kukjin

