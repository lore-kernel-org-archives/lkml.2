Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab0DHPL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:11:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab0DHPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:11:55 -0400
Subject: Re: [PATCH 3/6] perf tools: Reorganize some structs to save space
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1270737529-24258-4-git-send-email-acme@infradead.org>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
	 <1270737529-24258-4-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 17:11:49 +0200
Message-ID: <1270739509.20295.2419.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 11:38 -0300, Arnaldo Carvalho de Melo wrote:
> @@ -68,11 +68,11 @@ struct sample_data {
>         u64 addr;
>         u64 id;
>         u64 stream_id;
> -       u32 cpu;
>         u64 period;
> -       struct ip_callchain *callchain;
> +       u32 cpu;
>         u32 raw_size;
>         void *raw_data;
> +       struct ip_callchain *callchain;
>  }; 

If that is a struct that is to match a kernel produced record then this
is utterly broken.

