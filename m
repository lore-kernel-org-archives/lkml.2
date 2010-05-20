Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0ETRkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:40:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38758 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0ETRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:40:45 -0400
Date: Thu, 20 May 2010 10:38:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NR_CPUS configuration option wrong
Message-Id: <20100520103851.8e051a3f.randy.dunlap@oracle.com>
In-Reply-To: <ht3rr8$b5f$2@dough.gmane.org>
References: <ht3rr8$b5f$2@dough.gmane.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BF57419.00AE:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 18:34:32 +0100 Frank A. Kingswood wrote:

> Hi!
> 
> The configuration MAXSMP help text indicates it is used to enable 
> configuration of number of CPUs. However, NR_CPUS depends on !MAXSMP.
> 
> arch/x86/Kconfig:
> 758 config NR_CPUS
> 759         int "Maximum number of CPUs" if SMP && !MAXSMP

That line depends on !MAXSMP.  Then below there, we find:

	default "4096" if MAXSMP

OK?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
