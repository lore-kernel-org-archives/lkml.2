Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2KLW2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:28:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49687 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2KLW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:28:20 -0500
Date: Mon, 12 Nov 2012 14:28:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Thiago Farina <tfransosi@gmail.com>
cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 2/2] mm, oom: fix race when specifying a thread as the
 oom origin
In-Reply-To: <CACnwZYcUEmEStT7uwN3O3=m34uLi9YnJSYWFPZafuzCy_t4uaw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211121427580.29870@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1211080125150.3450@chino.kir.corp.google.com> <alpine.DEB.2.00.1211080126390.3450@chino.kir.corp.google.com> <20121108155112.GN31821@dhcp22.suse.cz> <CACnwZYcUEmEStT7uwN3O3=m34uLi9YnJSYWFPZafuzCy_t4uaw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Thiago Farina wrote:

> > I didn't like the previous playing with the oom_score_adj and what you
> > propose looks much nicer.
> > Maybe s/oom_task_origin/task_oom_origin/ would be a better fit
> May be s/oom_task_origin/is_task_origin_oom? Just my 2 cents.
> 

I like to prefix oom killer functions in the global namespace with "oom_"
