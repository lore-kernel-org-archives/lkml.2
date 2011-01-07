Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1AGW2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:28:23 -0500
Received: from smtp-out.google.com ([74.125.121.67]:46216 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1AGW16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LBT6g3w82MPnDHGZn6i04qXRv1aVSdJjlQ93s0JfvDd1yfgw+UOmQHRl7QVXtmxWMX
         jIUBGtMHf1EJmhEY5OGA==
Date: Fri, 7 Jan 2011 14:27:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Randy Dunlap <rdunlap@xenotime.net>, dle-develop@lists.sourceforge.net,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC][PATCH 1/2] Add explanation about min_free_kbytes to clarify
 its effect
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A297@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1101071426010.23818@chino.kir.corp.google.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com> <65795E11DBF1E645A09CEC7EAEE94B9C3A30A297@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Satoru Moriya wrote:

> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 30289fa..e10b279 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -349,7 +349,8 @@ min_free_kbytes:
>  
>  This is used to force the Linux VM to keep a minimum number
>  of kilobytes free.  The VM uses this number to compute a
> -watermark[WMARK_MIN] value for each lowmem zone in the system.
> +watermark[WMARK_MIN] for each lowmem zone and
> +watermark[WMARK_LOW/WMARK_HIGH] for each zone in the system.
>  Each lowmem zone gets a number of reserved free pages based
>  proportionally on its size.
>  

WMARK_MIN is changed for all zones.
