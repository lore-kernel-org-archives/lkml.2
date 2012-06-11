Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2FKUw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:52:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62477 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2FKUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:52:56 -0400
Date: Mon, 11 Jun 2012 13:52:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: cl@linux.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
In-Reply-To: <CAHGf_=rbss0RsoFn7NZ7oFCpCZuEYkPDXaHSW4KHg=Vu8703xA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1206111350550.6389@chino.kir.corp.google.com>
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1206110856180.31180@router.home> <4FD60127.1000805@jp.fujitsu.com> <alpine.DEB.2.00.1206111336370.4552@chino.kir.corp.google.com>
 <CAHGf_=rbss0RsoFn7NZ7oFCpCZuEYkPDXaHSW4KHg=Vu8703xA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, KOSAKI Motohiro wrote:

> > We do, and I think it would be a shame to break anything parsing the way
> > that this file has been written for the past several years for something
> > as aesthetical as this.
> 
> How do you parsing?
> 
> Several years, some one added ZVC stat. therefore, hardcoded line
> number parsing never work anyway. And in the other hand, if you are
> parsing, field
> name, my patch doesn't break anything.
> 

Yeah, your patch doesn't break me because I'm parsing by field name but I 
feel it would be a shame for it to break anyone else that may not be doing 
it that way.  The set of users in the world who are parsing /proc/zoneinfo 
who may or may not do crazy things is not fully represented on this 
thread, so I don't feel it's worth it.
