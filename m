Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2JPHNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:13:11 -0400
Received: from bluegiga.fi ([194.100.31.45]:42991 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab2JPHNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:13:10 -0400
Message-ID: <507D08FE.4070902@bluegiga.com>
Date: Tue, 16 Oct 2012 10:13:02 +0300
From: Lauri Hintsala <lauri.hintsala@bluegiga.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: SeongJae Park <sj38.park@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: csr: fix coding style
References: <1350287745-14442-1-git-send-email-sj38.park@gmail.com>
In-Reply-To: <1350287745-14442-1-git-send-email-sj38.park@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2012 07:13:02.0417 (UTC) FILETIME=[AE177410:01CDAB6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/15/2012 10:55 AM, SeongJae Park wrote:
> Fix coding style of csr_framework_ext_types.h
>
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> ---
>   drivers/staging/csr/csr_framework_ext_types.h |   33 +++++++++++--------------
>   1 file changed, 15 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
> index 57194ee..7e9cf8e 100644
> --- a/drivers/staging/csr/csr_framework_ext_types.h
> +++ b/drivers/staging/csr/csr_framework_ext_types.h
> @@ -2,11 +2,11 @@

...

> @@ -24,17 +24,15 @@ extern "C" {
>
>   #ifdef __KERNEL__
>
> -struct CsrThread
> -{
> -    struct task_struct *thread_task;
> -    char                name[16];
> +struct CsrThreadi {


I think this extra i letter at the end of CsrThreadi string is typo. Did 
you try to compile the driver with your changes?

Best regards,
Lauri Hintsala


> +	struct task_struct *thread_task;
> +	char                name[16];

...
