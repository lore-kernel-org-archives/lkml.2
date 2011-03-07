Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1CGRaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:30:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52224 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1CGRav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:30:51 -0500
Date: Mon, 7 Mar 2011 09:30:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add a guideline on notification of new
 userspace API/ABI elements
Message-Id: <20110307093026.42d62518.randy.dunlap@oracle.com>
In-Reply-To: <20110307113523.24025.37925.stgit@warthog.procyon.org.uk>
References: <20110307113523.24025.37925.stgit@warthog.procyon.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D75163C.02C6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 11:35:23 +0000 David Howells wrote:

> Add a guideline indicating who to notify about new userspace API/ABI elements,
> such as new system calls or error codes.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  MAINTAINERS |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 560ecce..694bec2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -63,7 +63,10 @@ trivial patch so apply some common sense.
>  	please Cc: security@kernel.org, especially if the maintainer
>  	does not respond.
>  
> -8.	Happy hacking.
> +8.	When adding new userspace API/ABI elements, notably system calls and
> +	error codes, please cc <linux-api@vger.kernel.org>.
> +
> +9.	Happy hacking.
>  
>  Descriptions of section entries:
>  
> 
> --

No objection other than I dislike having the same info in multiple places --
updates get out of sync easily and this is somewhat already in
Documentation/HOWTO and Documentation/SubmitChecklist.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
