Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0ERQEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:04:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0ERQEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:04:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=GmRNO+U173dNRWx7+vP+o0/UvOoF+QwXPTRet3fk9W1+h7CGqp2Q1+SPzDHQlStoE
	8IL8wd6Kg+3pTYtsLT11Q==
MIME-Version: 1.0
In-Reply-To: <1274196043.5605.8161.camel@twins>
References: <1273886490-15627-1-git-send-email-venki@google.com>
	 <1274084399.5605.3655.camel@twins>
	 <AANLkTikWWEYpwmqhQ0oYz30SUFY-y2erqStw2T6h0WXg@mail.gmail.com>
	 <1274117717.1674.1539.camel@laptop>
	 <AANLkTik4EvvSwz9rD3zemuaSN3FMAIqsncZ5AKYOdaEn@mail.gmail.com>
	 <AANLkTilLtDWQsAUrIxJ6s04WTgmw9GuOODc5AOrYsaR5@mail.gmail.com>
	 <1274196043.5605.8161.camel@twins>
Date: Tue, 18 May 2010 09:04:19 -0700
Message-ID: <AANLkTilbn9JnFmjcKfCuqqN0VgDw0m1nRbW3iqamEMWf@mail.gmail.com>
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on 
	update_cpu_load (v2)
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 8:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-05-17 at 18:14 -0700, Venkatesh Pallipadi wrote:
>> Does this look better?
>
> Yes, although whitespace challenged, but I fixed it up.
>

Sorry about the whitespace noise. That means I still have to figure
out howto reply a patch to an email with my new email client :(

Thanks,
Venki
