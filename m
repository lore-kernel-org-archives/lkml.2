Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1ALUQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:16:35 -0500
Received: from smtp-out.google.com ([74.125.121.67]:39573 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1ALUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GM4psSPyFJUO5mkc57rb2GpWsL4Ac8kQM1by5QjSQGzZL99qdQBTqEkCb2NB/nN+JT
         VJN2AKOr7JCTuaiI+TVg==
Date: Wed, 12 Jan 2011 12:16:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric B Munson <emunson@mgebm.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rename struct task variables from p to tsk
In-Reply-To: <1294845571-11529-1-git-send-email-emunson@mgebm.net>
Message-ID: <alpine.DEB.2.00.1101121215370.31521@chino.kir.corp.google.com>
References: <1294845571-11529-1-git-send-email-emunson@mgebm.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Eric B Munson wrote:

> p is not a meaningful identifier, this patch replaces all instances
> in page_alloc.c of p when used as a struct task with the more useful
> tsk.
> 

mm-page_allocc-dont-cache-current-in-a-local.patch removes all of the 
stack allocations changed in this patch, so it's not needed.
