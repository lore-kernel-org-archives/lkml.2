Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1JaRrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:47:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322Ab1JaRrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:47:02 -0400
Date: Mon, 31 Oct 2011 18:42:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: rientjes@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, stable@kernel.org, eteo@redhat.com,
        pmatouse@redhat.com
Subject: Re: [PATCH v2] oom: fix integer overflow of points in oom_badness
Message-ID: <20111031174238.GA7344@redhat.com>
References: <1320048865-13175-1-git-send-email-fhrbata@redhat.com> <1320076569-23872-1-git-send-email-fhrbata@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320076569-23872-1-git-send-email-fhrbata@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Frantisek Hrbata wrote:
>
>  unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  		      const nodemask_t *nodemask, unsigned long totalpages)
>  {
> -	int points;
> +	long points;

Good catch. Imho this is the stable material.

Acked-by: Oleg Nesterov <oleg@redhat.com>

