Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1DUCR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:17:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33662 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1DUCR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dnCHJfwFtwPOuzHOTYyLj6gatFMwpIku1zhm+P/dZR1yU/iP9Kq2+VgKJXZmONeRH9
         cYp76jFjYTPwhQzqz2Zg==
Date: Wed, 20 Apr 2011 19:17:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc4 (regression: NUMA on multi-node CPUs broken)
In-Reply-To: <20110421110452.7322.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104201916490.12634@chino.kir.corp.google.com>
References: <20110420153907.GA9000@alberich.amd.com> <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com> <20110421110452.7322.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, KOSAKI Motohiro wrote:

> Simple revert 7d6b46707f24 makes the same boot failure again.
> 

Do you have CONFIG_DEBUG_PER_CPU_MAPS enabled?  If not, please send your 
.config.
