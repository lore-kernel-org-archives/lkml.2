Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab0JYUk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:40:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab0JYUkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TZxneHilNscyaOAq/pmb2YB57blx5LN4DuKhNe3Eix612Dfhp3cJiICrPmccCHnDrL
         Mz8+zABVB5Wg9ecVznxg==
Date: Mon, 25 Oct 2010 13:40:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101025122723.916D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010251338081.21737@chino.kir.corp.google.com>
References: <20101025122538.9167.A69D9226@jp.fujitsu.com> <20101025122723.916D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010, KOSAKI Motohiro wrote:

> oom_adj is not only used for kernel knob, but also used for
> application interface. Then, adding new knob is no good
> reason to deprecate it. Don't do stupid!
> 

NACK as a logical follow-up to my NACK for "oom: remove totalpage 
normalization from oom_badness()"
