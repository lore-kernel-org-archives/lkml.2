Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0FHTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:09:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab0FHTJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:09:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=XcrxkTOEfSj3kC2HpfMbYHZRkOLYGX3rcQt6zRgpX0jc5RyHz/hr7TfOIluhz12SS
	zvdC+Gj62J0WhJexBZLGw==
Date: Tue, 8 Jun 2010 12:09:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 03/10] oom: rename badness() to oom_badness()
In-Reply-To: <20100608205536.7683.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006081208010.23776@chino.kir.corp.google.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608205536.7683.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, KOSAKI Motohiro wrote:

> badness() is wrong name because it's too generic name.
> 
> rename it.
> 

This is already renamed in my heuristic rewrite which we all agree, in 
principle, is needed.  I'm really confused that you're trying to take 
little bits and pieces of my work like this, using my name for the 
function in this case, for example, and not working with other developers 
in reviewing their work.
