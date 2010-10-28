Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab0J1PdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:33:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:9917 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab0J1PdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:33:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,252,1286175600"; 
   d="scan'208";a="851919220"
Message-ID: <4CC997B2.1060002@linux.intel.com>
Date: Thu, 28 Oct 2010 08:33:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation (v2)
References: <20101028153117.GA4051@Krystal>
In-Reply-To: <20101028153117.GA4051@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 8:31 AM, Mathieu Desnoyers wrote:
> DEFINE_TRACE should also exist when CONFIG_EVENT_TRACING=n. Otherwise, setting
> only TRACEPOINTS=y is broken.
>
> Changelog since v1:
> - Only change the makefiles, as required.
> - Patch based on 2.6.36 mainline kernel.
>
> Signed-off-by: Mathieu Desnoyers<mathieu.desnoyers@efficios.com>
> CC: Arjan van de Ven<arjan@linux.intel.com>
> CC: Steven Rostedt<rostedt@goodmis.org>


Acked-by: Arjan van de Ven <arjan@linux.intel.com>

