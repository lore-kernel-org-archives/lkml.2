Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab0EFRnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:43:53 -0400
Received: from xenotime.net ([72.52.115.56]:33901 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759158Ab0EFRnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:43:51 -0400
Date: Thu, 6 May 2010 10:43:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, ysato@users.sourceforge.jp, tony.luck@intel.com,
       dhowells@redhat.com, kyle@mcmartin.ca, benh@kernel.crashing.org,
       schwidefsky@de.ibm.com, jgarzik@pobox.com, hare@suse.de,
       felipe.balbi@nokia.com
Subject: Re: [PATCH] removing redundant ifdefs
Message-Id: <20100506104343.96d6a952.rdunlap@xenotime.net>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 May 2010 19:36:04 +0200 Jiri Olsa wrote:

> removing redundant ifdefs.
> 
> the pattern is
> 
> 	#ifdef DEF1
> 	...
> 	#ifdef DEF1
> 	...
> 	#endif
> 	...
> 	#endif
> 
> and removing the inner ifdef.
> 
> I found them using script all over the kernel so
> I haven't even compile-tested some of them.

what script, please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
