Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab1FUTIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:08:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab1FUTID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kf9CpoT5s03LQchlpPJ8Pvc/VOi+Jg98LiDrCY6uQv0u3sELz+mK3Z7R7FXv5OVjRE
         LYQtQKVKrhODNgNQivBQ==
Date: Tue, 21 Jun 2011 12:07:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frantisek Hrbata <fhrbata@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, lwoodman@redhat.com
Subject: Re: [PATCH] oom: add uid to "Killed process" message
In-Reply-To: <20110621113629.GA2758@dhcp-26-164.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.1106211205290.30481@chino.kir.corp.google.com>
References: <1308567876-23581-1-git-send-email-fhrbata@redhat.com> <alpine.DEB.2.00.1106201409090.2639@chino.kir.corp.google.com> <20110621113629.GA2758@dhcp-26-164.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, Frantisek Hrbata wrote:

> I guess the uid of the killed process can be identified from the dump_tasks
> output, where it is presented along with other info. I think it is handy
> to have the uid info directly in the "Killed process" message. 
> 
> This is used/requested by one of our customers and since I think it's a good
> idea to have the uid info presented, I posted the patch here to see what do you
> think about it.
> 

I don't feel strongly about it, but I think you could justify adding a lot 
of the same information from the tasklist dump to the single "Killed 
process" message.  The optimal way of getting this information would be 
from the tasklist dump.
