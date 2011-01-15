Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1AOXk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:40:58 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:42134 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1AOXk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:40:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g7nLPR1zZQdCgS+Eebp3nR1sqKXi5ZqALfsP7AHOi2ltDmlgTLnNMhzgBG/BNkCfZW
         +e6HQdw8E0RpukhvNpOaFr8tA457Lkud1iubmzAef5vHiIghJEkMGeF7fwpf1DOJcjR3
         IA+WYmQ+jpmQshazOMdFZNWzwccHwQcCqqElo=
Date: Sun, 16 Jan 2011 00:40:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 03/28] trace event bkl remove semicolons
Message-ID: <20110115234049.GB1768@nowhere>
References: <20110109215927.633266833@efficios.com>
 <20110109220508.578236558@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109220508.578236558@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 04:59:30PM -0500, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
