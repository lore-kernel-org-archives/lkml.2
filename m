Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0HSUgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:36:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0HSUgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:36:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hSrKTHnPr1heXrz36EoUN1yPBu73d5XLex7dB1sspkfTCKTnk3WYL1QPqAyVD0hZu
	Jqid+NhJcQWE+0reFJS6w==
Date: Thu, 19 Aug 2010 13:35:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] oom: fix NULL pointer dereference
In-Reply-To: <20100819195310.5FC7.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1008191335370.18994@chino.kir.corp.google.com>
References: <20100819194707.5FC4.A69D9226@jp.fujitsu.com> <20100819195310.5FC7.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, KOSAKI Motohiro wrote:

> commit b940fd7035 (oom: remove unnecessary code and cleanup) added
> unnecessary NULL pointer dereference. remove it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
