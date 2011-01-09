Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1AIWKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:10:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35268 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1AIWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:10:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ieRWAW6WvWTdBLiTRVSHW83lIBTizPKJGjsAbEbS6s1xfYjJ/mdujV6RulXoPOAGIl
         Ueah9dXDg5uZ7Yc6ZPc0EvVvJAcAknreei5FVEqtmw8HR9tv/s8MFpAGnPJSIhvnNijf
         +PMqlw//G4IHak0g45cbv8riYprh9dFEFIW6s=
Date: Sun, 9 Jan 2011 17:10:25 -0500
From: Tejun Heo <tj@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC patch 23/28] trace event workqueue remove semicolons
Message-ID: <20110109221025.GB25707@mtj.dyndns.org>
References: <20110109215927.633266833@efficios.com>
 <20110109220511.867823199@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109220511.867823199@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 04:59:50PM -0500, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
