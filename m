Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2KSBGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 20:06:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64863 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KSBGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 20:06:12 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1b-50a986028089
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Andy Whitcroft'" <apw@canonical.com>, peter@hurleysoftware.com,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20121030211530.09F1320004E@hpza10.eem.corp.google.com>
 <1353046873.24310.30.camel@joe-AO722> <1353094271.2512.15.camel@joe-AO722>
In-reply-to: <1353094271.2512.15.camel@joe-AO722>
Subject: Re: [PATCH V2] checkpatch: extend line continuation test
Date: Mon, 19 Nov 2012 10:06:10 +0900
Message-id: <004901cdc5f2$1032e1e0$3098a5a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3EMPC85G2AEgxwSLCm4GPl94KE5QBwOraA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zfV3mtpUBBlsXMlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Maec2MRU0c1bc3r2UvYHxPVsXIyeHhICJxMPb+9khbDGJC/fW
	g8WFBJYxSmz8KwxTc3/ye6YuRi6g+HRGiXuT5rBBOLOZJJ5ufQzWwSagJvHly2GwSSICARKt
	3y+AFTEL9DNKrGr8C9UxgVFi09RZrCBVnAKGEhM+vwHrEBZwlJjzuo8RxGYRUJW42dHKDGLz
	CthK7H6zlB3CFpT4MfkeC4jNLKAlsXlbEyuELS+xec1boHoOoFvVJR791YU4wkjiV+ccqHIR
	iX0v3kGNF5D4NvkQC0S5rMSmA8wgp0kILGKXuDu/BxoUkhIHV9xgAbp2FpLNs5BsnoVk8ywk
	KxYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECIkuqR2MKxssDjEKcDAq8fDuMFgRIMSa
	WFZcmXuIUYKDWUmEV9NyZYAQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wMjP68k3tDY2MTM
	xNTE3NLU3BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGxoOTJ0r1ugozF+TzXXi+5OKy
	C/n32lWtglra78Tl35lyL9Fe6a1bDxN37+s8loVpNs//T70V4lem/fX5inNX99zs/pbqHrjL
	Xevp5YUnuuVud2p/NjD7dpMxMVGqIlXWWnX1+s/vmtz+tfr6vJ4psfurrXXld82Edxr3MtYa
	qS7uSNQoTGfZq8RSnJFoqMVcVJwIAAlIRgjbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV2mtpUBBjMPWllc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjGnnNjEVNHNW3N69lL2B
	8T1bFyMnh4SAicT9ye+ZIGwxiQv31gPFuTiEBKYzStybNAfKmc0k8XTrY7AONgE1iS9fDrOD
	2CICARKt3y+AFTEL9DNKrGr8C9UxgVFi09RZrCBVnAKGEhM+vwHrEBZwlJjzuo8RxGYRUJW4
	2dHKDGLzCthK7H6zlB3CFpT4MfkeC4jNLKAlsXlbEyuELS+xec1boHoOoFvVJR791YU4wkji
	V+ccqHIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwdH7TGoH48oGi0OMAhyMSjy8OwxWBAixJpYVV+YeYpTgYFYS4dW0XBkgxJuSWFmVWpQf
	X1Sak1p8iNEH6NGJzFKiyfnAxJJXEm9obGJmZGlkZmFkYm6OQ1hJnLfZIyVASCA9sSQ1OzW1
	ILUIZhwTB6dUA6NPv4Vj9BHLwrZXEWX6/9bGeWiyPhK1S/h+7ag6y66UgCM7ZA5X5f2+OVv9
	tM3cB/U+W1cKzPb4Pe3R+6cCZX4rXhqfWd1o7GMT16B12+a35rE/LCUC1gomH04pqm+V9srf
	PMldTenODbNFm6zd1D477s6f+D7YLy1eUOTj218sDa+Tt+7kfKDEUpyRaKjFXFScCAD/q0HU
	CwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 17, 2012 4:31 AM, Joe Perches wrote
> 
> Preprocessor directives and asm statements should be
> allowed to have a line continuation.
> 
> Signed-off-by: Joe Perches <joe@perches.com>


Tested-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han


> ---
> V2:
> Make the check for preprocessor directives work properly
> # is not optional.
> 
>  scripts/checkpatch.pl |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d2d5ba1..bfb06ee 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3006,10 +3006,12 @@ sub process {
>  				}
>  			}
> 
> -# check for line continuations outside of #defines
> +# check for line continuations outside of #defines, preprocessor #, and asm
> 
>  		} else {
>  			if ($prevline !~ /^..*\\$/ &&
> +			    $line !~ /^\+\s*\#.*\\$/ &&		# preprocessor
> +			    $line !~ /^\+.*\b(__asm__|asm)\b.*\\$/ &&	# asm
>  			    $line =~ /^\+.*\\$/) {
>  				WARN("LINE_CONTINUATIONS",
>  				     "Avoid unnecessary line continuations\n" . $herecurr);


