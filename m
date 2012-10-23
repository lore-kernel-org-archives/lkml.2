Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2JWDXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:23:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51174 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2JWDXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:23:40 -0400
X-AuditID: cbfee61b-b7f616d00000319b-87-50860dbabce3
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Max Filippov'" <jcmvbkbc@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <001701cdb0c6$21c2a530$6547ef90$%kim@samsung.com> <508608C6.7050605@gmail.com>
In-reply-to: <508608C6.7050605@gmail.com>
Subject: RE: [PATCH 07/16 v2] f2fs: add segment operations
Date: Tue, 23 Oct 2012 12:23:38 +0900
Message-id: <002801cdb0cd$cb0bb9e0$61232da0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2wyt2FwxcAK/QeQ5eaSiRyvBiCJwAAtdpQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ91dvG0BBisfGFjs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU0/frMVLCLs+Lvl3+sDYx32bsYOTkkBEwkOudOgrLF
	JC7cW8/WxcjFISSwjFFi3rJzbDBFM492sIDYQgLTGSW+fyuEKPrHKLF20magIg4ONgFtic37
	DUBqRATUJc5+vsQMUsMs8JBRYs7NE+wQDX2MEvc3XQObxCmgKbHlyENWkGZhASuJnb02IGEW
	AVWJh2fPMoPYvAK2Evu/d0PZghI/Jt8Da2UGWjBp3iJmCFteYvOat8wgYySA4o/+6kLcYCTx
	//8ydogSEYl9L94xQowXkPg2+RALRLmsxKYDYGdKCCxjl2j818YE8a+kxMEVN1gmMErMQrJ5
	FpLNs5BsnoVkxQJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYITEmvYNxVYPFIUYBDkYl
	Ht6O/a0BQqyJZcWVuYcYJTiYlUR4lQOAQrwpiZVVqUX58UWlOanFhxh9gC6fyCwlmpwPjP+8
	knhDY2MTMxNTE3NLU3NTHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhh7zocdzQvcf27V
	Qb2UPUb6vOrPO9J3nmw6+CtIJe597Y7UxVY3eGTZ/v8viNA2PK8aK7khS0LbJO4z+62D9pdf
	Fmyvz7XsW3PkpLjGR4a/vvlu6+zKNl+zWrl4smSY+UO7bpGrNx/ns2hOmBGWscOj2LZv0fQ3
	RxKMOY6uZlwmJ3dwVcvvc4VKLMUZiYZazEXFiQCzPYNy3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd1dvG0BBseadC327D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzmn59ZirYxVnx
	98s/1gbGu+xdjJwcEgImEjOPdrBA2GISF+6tZwOxhQSmM0p8/1bYxcgFZP9jlFg7aTNQgoOD
	TUBbYvN+A5AaEQF1ibOfLzGD1DALPGSUmHPzBDtEQx+jxP1N18CmcgpoSmw58pAVpFlYwEpi
	Z68NSJhFQFXi4dmzzCA2r4CtxP7v3VC2oMSPyffAWpmBFkyat4gZwpaX2LzmLTPIGAmg+KO/
	uhA3GEn8/7+MHaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnAEP5PewbiqweIQowAHoxIPb8f+1gAh1sSy4srcQ4wSHMxKIrzKAUAh3pTE
	yqrUovz4otKc1OJDjD5Aj05klhJNzgcml7ySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJ
	JanZqakFqUUw45g4OKUaGPs6d0ZsYUvOab7/L9S1duO3w/sZXVfcb3FilfNZbCzYeEKLZ1v6
	J78cd8+ZBdd37fNecORAwxV+hq6JV4pmsDVF7W4JUH2d+WKPWzKz4pnd7L425+/XfWlc6sqt
	8bs37ITHrMiuQN4JpbYiAdNWbHymyuzdX5J2P+Cy2Rmt+q/TDe31zBK/KbEUZyQaajEXFScC
	AAJsC1oNAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi.
> 
> Building f2fs for ARM gives the following error:
> 
>   CC      fs/f2fs/segment.o
>   CC      fs/f2fs/recovery.o
> fs/f2fs/segment.c: In function 'build_sit_info':
> fs/f2fs/segment.c:1399:2: error: implicit declaration of function 'vzalloc' [-Werror=implicit-
> function-declaration]
> fs/f2fs/segment.c:1399:18: warning: assignment makes pointer from integer without a cast [enabled by
> default]
> fs/f2fs/segment.c:1419:22: warning: assignment makes pointer from integer without a cast [enabled by
> default]
> fs/f2fs/segment.c: In function 'destroy_sit_info':
> fs/f2fs/segment.c:1777:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-
> declaration]
> cc1: some warnings being treated as errors
> 
> The following fixes that:
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 57d0931..5bab838 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -12,6 +12,7 @@
>  #include <linux/f2fs_fs.h>
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> +#include <linux/vmalloc.h>
> 
>  #include "f2fs.h"
>  #include "segment.h"
> 

Thank you very much.
I'll apply this in v3.

> --
> Thanks.
> -- Max

