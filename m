Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1ECIZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:25:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63816 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1ECIZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NqZwuvPD6qEBk8OaopB4WzQkNoslyhusUbjw1FwbwQAOBp7zh4dovvH7CBr2sB4CRJ
         U+HKYnnFgi1JtfCENVRVP2olzeL9ljjUCVXL1uTBz63aToawChT0gG3ShDdrWXUcOL3O
         WotZm2CxRGopyKMZzWeVQvd0fG19UJkYopRzI=
Date: Tue, 3 May 2011 10:25:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC patch 22/32] trace event workqueue remove semicolons
Message-ID: <20110503082517.GB6556@htj.dyndns.org>
References: <20110502211123.163877033@efficios.com>
 <20110502213214.872566459@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502213214.872566459@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:11:45PM -0400, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Arjan van de Ven <arjan@linux.intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
