Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab1D2Xsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:48:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40990 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab1D2Xsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:48:35 -0400
Date: Fri, 29 Apr 2011 16:47:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v4 1/3] driver: Google EFI SMI
Message-Id: <20110429164736.fd84f2ae.randy.dunlap@oracle.com>
In-Reply-To: <20110429225551.22013.65012.stgit@mike.mtv.corp.google.com>
References: <20110429212328.GA19207@kroah.com>
	<20110429225551.22013.65012.stgit@mike.mtv.corp.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DBB4E1E.005C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 15:55:51 -0700 Mike Waychison wrote:


> +static int gsmi_die_callback(struct notifier_block *nb,
> +			     unsigned long reason, void *arg)
> +{
> +	if (reason == DIE_NMIWATCHDOG)
> +		gsmi_shutdown_reason(GSMI_SHUTDOWN_NMIWDT);
> +	else if (reason == DIE_OOPS)
> +		gsmi_shutdown_reason(GSMI_SHUTDOWN_OOPS);
> +	return NOTIFY_DONE;
> +}


Where is DIE_NMIWATCHDOG defined?
Do I need more that patches 1,2,3/3 applied?


lnx-2639-rc5/drivers/firmware/google/gsmi.c: In function 'gsmi_die_callback':
lnx-2639-rc5/drivers/firmware/google/gsmi.c:660: error: 'DIE_NMIWATCHDOG' undeclared (first use in this function)
lnx-2639-rc5/drivers/firmware/google/gsmi.c:660: error: (Each undeclared identifier is reported only once
lnx-2639-rc5/drivers/firmware/google/gsmi.c:660: error: for each function it appears in.)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
