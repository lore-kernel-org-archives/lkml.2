Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1D2HJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:09:57 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52332 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1D2HJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:09:56 -0400
Date: Fri, 29 Apr 2011 09:09:53 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Thiago Farina <tfransosi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: convert old cpumask API into new one
Message-ID: <20110429070953.GA2481@osiris.boeblingen.de.ibm.com>
References: <20110429000304.3D60.A69D9226@jp.fujitsu.com>
 <BANLkTi=FwXMo=qRAS=1ORDF28kxXiR=G3Q@mail.gmail.com>
 <20110429004726.3D83.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429004726.3D83.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 29 Apr 2011 00:44:43 +0900
> Subject: [PATCH] s390: coding style fix
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  arch/s390/kernel/smp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 4cc09b8..a80798b 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -1021,7 +1021,7 @@ int __ref smp_rescan_cpus(void)
>  	if (rc)
>  		goto out;
>  	cpumask_andnot(&newcpus, cpu_present_mask, &newcpus);
> -	for_each_cpu(cpu,&newcpus) {
> +	for_each_cpu(cpu, &newcpus) {
>  		rc = smp_add_present_cpu(cpu);
>  		if (rc)
>  			set_cpu_present(cpu, false);

Applied and merged both to our tree.
Thanks!
