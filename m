Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab2EXKze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:55:34 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34876 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2EXKzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:55:33 -0400
Date: Thu, 24 May 2012 12:56:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120524105604.GC27063@aftab.osrc.amd.com>
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com>
 <1337854460-25191-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337854460-25191-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:14:20AM -0300, Mauro Carvalho Chehab wrote:
> + * Default error mechanisms for Memory Controller errors (CE and UE)
> + */
> +TRACE_EVENT(mc_event,
> +
> +	TP_PROTO(const unsigned int err_type,
> +		 const unsigned int mc_index,
> +		 const char *error_msg,
> +		 const char *label,
> +		 int layer0,
> +		 int layer1,
> +		 int layer2,
> +		 unsigned long address,
> +		 unsigned long grain,
> +		 unsigned long syndrome,
> +		 const char *driver_detail),

What about the comments I had about layer{0,1,2} and grain?

http://marc.info/?l=linux-edac&m=133769207124938&w=2

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
