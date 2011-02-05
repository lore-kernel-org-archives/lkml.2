Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1BECcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 21:32:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33791 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1BECcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 21:32:01 -0500
Date: Fri, 4 Feb 2011 18:31:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-02-04-15-15 uploaded (printk
 DEFAULT_MESSAGE_LOGLEVEL)
Message-Id: <20110204183126.ac5c2d66.randy.dunlap@oracle.com>
In-Reply-To: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
References: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D4CB697.00E5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Feb 2011 15:15:17 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-02-04-15-15 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.38-rc3:

When CONFIG_PRINTK is not enabled:

mmotm-2011-0204-1515/kernel/printk.c:66: error: 'CONFIG_DEFAULT_MESSAGE_LOGLEVEL' undeclared here (not in a function)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
