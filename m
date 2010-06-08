Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0FHTKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:10:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0FHTKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:10:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=GlW2vQtg7YOMVRBGcQ+Pp53lUFcAMwF+8VNj5gG0aYaA8NxB+Y5ltPRYl3WfkPO1q
	3XL5/PhC+5EYbEQ2t6xMw==
Date: Tue, 8 Jun 2010 12:09:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 02/10] oom: remove verbose argument from
 __oom_kill_process()
In-Reply-To: <20100608205454.7680.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006081209330.23776@chino.kir.corp.google.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608205454.7680.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, KOSAKI Motohiro wrote:

> Now, verbose argument is unused. This patch remove it.
> 

This is already done in my oom killer rewrite, please work with other 
developers in developing their work instead of acting as a maintainer, 
which you aren't.
