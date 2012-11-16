Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2KPG2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:28:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21519 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2KPG2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:28:41 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1b-50a5dd17b8cb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Andy Whitcroft'" <apw@canonical.com>, peter@hurleysoftware.com,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20121030211530.09F1320004E@hpza10.eem.corp.google.com>
 <1353046873.24310.30.camel@joe-AO722>
In-reply-to: <1353046873.24310.30.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: extend line continuation test
Date: Fri, 16 Nov 2012 15:28:39 +0900
Message-id: <001e01cdc3c3$9d9e51d0$d8daf570$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3DwpVUY3/4O338T46dJ1hhrrIJWAAAFsoQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zA13xu0sDDNbN0LO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZiw/fZCs4x1ExaeIltgbGY2xdjJwcEgImEpNubWGHsMUkLtxb
	DxTn4hASWMYosWjDdEaYoq1HLzFDJBYxSqy5/YIZJCEkMJtJYu4iAxCbTUBN4suXw2CTRAQC
	JFq/XwCbxCzQzyixqvEvG0RDtsStdc9YQGxOASOJJW3bWEFsYQE7iTd/W8GGsgioSrQ9XgAW
	5xWwlVhyYxMThC0o8WPyPbBeZgEtifU7jzNB2PISm9e8BerlALpUXeLRX12IG4wkGjY+ZoUo
	EZHY9+IdI8R4AYlvkw+xQJTLSmw6APaXhMAidonNF7ezQjwsKXFwxQ2WCYwSs5BsnoVk8ywk
	m2chWbGAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRkhsSe1gXNlgcYhRgINRiYdX8PbS
	ACHWxLLiytxDjBIczEoivEk1QCHelMTKqtSi/Pii0pzU4kOMPkCXT2SWEk3OB8Z9Xkm8obGx
	iZmJqYm5pam5KQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2Mi2smcv78XmngrBDxM7Ge
	aWkbj+CiV3fqeetPm3t897j0t2CLj2JF1heNuvCV06Kvzzon+bJ6LePFUnGbXWLHQ/cdjQje
	w6dno3vriUaCdXPgpbsNkidCflrP7i53NhZm0BVeYruG9Za6WSLXnLusmnZ3Jvw90bPefoFg
	cIFz27KE4693yaYpsRRnJBpqMRcVJwIAjcZtd9oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAV3xu0sDDD73a1hc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMWHb7IVnOOomDTxElsD
	4zG2LkZODgkBE4mtRy8xQ9hiEhfurQeKc3EICSxilFhz+wVYQkhgNpPE3EUGIDabgJrEly+H
	2UFsEYEAidbvF8AamAX6GSVWNf5lg2jIlri17hkLiM0pYCSxpG0bK4gtLGAn8eZvK9hQFgFV
	ibbHC8DivAK2EktubGKCsAUlfky+B9bLLKAlsX7ncSYIW15i85q3QL0cQJeqSzz6qwtxg5FE
	w8bHrBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS
	83M3MYIj95nUDsaVDRaHGAU4GJV4eAVvLw0QYk0sK67MPcQowcGsJMKbVAMU4k1JrKxKLcqP
	LyrNSS0+xOgD9OhEZinR5HxgUskriTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCeWJKanZpa
	kFoEM46Jg1OqgbFkbXtGKef+a6q6dqLhu1+rJPgl3P4ZU2C6zjPJ+c9MCz+TGWf2fdvPv55X
	zzx1EsvcSo5Pi2ubm59W1xmzff68ZveBoqMydwsvH+W68vX4X232yAhN1qcL4z82vrYKO6r6
	vkpmqfTlW3knNXjZ1HllH042X80a/u6EuMDkuKsLL/ZEKqXPPaLEUpyRaKjFXFScCADgbSGL
	CQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 16, 2012 3:21 PM, Joe Perches wrote
> 
> Preprocessor directives and asm statements should be
> allowed to have a line continuation.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Hi Joe Perches,

It works properly. :)

Tested-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> ---
>  scripts/checkpatch.pl |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d2d5ba1..019f9be 100755
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
> +			    $line !~ /^\+\s*\#*.*\\$/ &&	# preprocessor
> +			    $line !~ /^\+.*\b(__asm__|asm)\b.*\\$/ &&	# asm
>  			    $line =~ /^\+.*\\$/) {
>  				WARN("LINE_CONTINUATIONS",
>  				     "Avoid unnecessary line continuations\n" . $herecurr);


