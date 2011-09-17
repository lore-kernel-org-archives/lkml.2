Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab1IQEvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 00:51:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1IQEvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 00:51:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=rrsuP0QLUTfuSWtyjgRkoSapkTcdbu/XwG0e5jBL7NN9af5V8lEgqg1v+tM2By8xO
	KkNS6ne8htn9n/GUN3nUg==
MIME-Version: 1.0
In-Reply-To: <1316231069.27917.28.camel@Joe-Laptop>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<1316230753-8693-2-git-send-email-walken@google.com>
	<1316231069.27917.28.camel@Joe-Laptop>
Date: Fri, 16 Sep 2011 21:51:34 -0700
Message-ID: <CANN689Em19_T1i6KjeH9JKNZ7ohN6dRz4Yg19+qT0h8ywAVhxQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] page_referenced: replace vm_flags parameter with
 struct pr_info
From: Michel Lespinasse <walken@google.com>
To: Joe Perches <joe@perches.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 8:44 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2011-09-16 at 20:39 -0700, Michel Lespinasse wrote:
>> Introduce struct pr_info, passed into page_referenced() family of functions,
>
> pr_info is a pretty commonly used function/macro.
> Perhaps pageref_info instead?

Hmm, you're right. I can see how people could find this confusing.
I'll make sure to change the name before this gets accepted.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
