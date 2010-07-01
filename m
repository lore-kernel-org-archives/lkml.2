Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0GAX35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:29:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28776 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0GAX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:29:54 -0400
Date: Thu, 1 Jul 2010 16:28:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-07-01-12-19 uploaded (mmc)
Message-Id: <20100701162842.2ecafbbb.randy.dunlap@oracle.com>
In-Reply-To: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C2D24E7.028B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010 12:19:51 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-07-01-12-19 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.35-rc3:


mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch:

if CONFIG_PM is not enabled:

(.text+0xc380c4): undefined reference to `mmc_pm_notify'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
