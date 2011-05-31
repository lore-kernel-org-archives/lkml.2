Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1EaEsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 00:48:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1EaEsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 00:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=aKhNCLEIG/Jsv41/z5cWI+RuG+1o8JHHT5PM4PMOqvaH6YdgvZKs0zJiVv4Aq+UKm6
         L+KqqwYO5/NQEg5b8fpQ==
Date: Mon, 30 May 2011 21:48:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
In-Reply-To: <4DE2F028.6020608@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105302147250.18793@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com> <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com> <4DDB0B45.2080507@jp.fujitsu.com> <alpine.DEB.2.00.1105231838420.17729@chino.kir.corp.google.com>
 <4DDB1028.7000600@jp.fujitsu.com> <alpine.DEB.2.00.1105231856210.18353@chino.kir.corp.google.com> <4DDB11F4.2070903@jp.fujitsu.com> <alpine.DEB.2.00.1105251645270.29729@chino.kir.corp.google.com> <4DE2F028.6020608@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, KOSAKI Motohiro wrote:

> Never mind.
> 
> You never see to increase tasklist_lock. You never seen all processes
> have root privilege case.
> 

I don't really understand what you're trying to say, sorry.
