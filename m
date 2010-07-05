Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0GEAc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 20:32:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:52149 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab0GEAc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 20:32:57 -0400
Date: Mon, 5 Jul 2010 10:32:19 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jiri Slaby <jslaby@suse.cz>
cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/12] rlimits: security, add task_struct to
 setrlimit
In-Reply-To: <4C2DCDE8.7050905@suse.cz>
Message-ID: <alpine.LRH.2.00.1007051031240.21265@tundra.namei.org>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz> <alpine.LRH.2.00.1006240957350.1601@tundra.namei.org> <4C2DCDE8.7050905@suse.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010, Jiri Slaby wrote:

> On 06/24/2010 01:58 AM, James Morris wrote:
> > On Wed, 23 Jun 2010, Jiri Slaby wrote:
> >> Add task_struct to task_setrlimit of security_operations to be able to set
> >> rlimit of task other than current.
> > 
> > Given the scope of the changes, I'm not sure which tree these should go 
> > into.  They affect the security API, so possibly mine.
> 
> If there are no objections, could you take it? Or maybe Andrew, if we
> persuaded him?

A bunch of these patches have no acked-by or reviewed-by, which means 
they still need to be reviewed.



- James
-- 
James Morris
<jmorris@namei.org>
