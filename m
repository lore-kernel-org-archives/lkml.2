Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0LFO7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:59:20 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:34337 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0LFO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BrOv41SeNdo1jRKF3OqA6HTKj7eb8vZ8HVjqsPjgIC7y7k68rT6t6cJrL/jxf1rv+B
         fmyMWHb8VikZLgj8JSkuSg6aU2z28AUN0zrGyFPU4SPhE+w5CQiigHqgKt8Te8/OR1L4
         OuOhTypM+oigvrhgXa13BfwmS2/dbiGyAoO5c=
Date: Mon, 6 Dec 2010 17:59:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] perf: Prevent potential null dereference
Message-ID: <20101206145910.GA6487@lenovo>
References: <20101202222605.GA6471@lenovo> <20101202224104.GA1639@nowhere> <20101202224609.GA31473@ghostprotocols.net> <20101205221321.GD7799@lenovo> <20101206144954.GA25943@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101206144954.GA25943@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 12:49:55PM -0200, Arnaldo Carvalho de Melo wrote:
...
> 
> Hey, what tree is this agains? I guess tip/master, right? If so, I still
> didn't got there :-\

yup, it was -tip/master

 | commit 93edb4532cbdbc174a64ec4ab347a345159bc93e
 | Merge: 913b7a9 11e8896
 | Author: Ingo Molnar <mingo@elte.hu>
 | Date:   Sat Dec 4 11:28:13 2010 +0100
 |
 |   Merge branch 'linus'

> 
> - Arnaldo
> 
  Cyrill
