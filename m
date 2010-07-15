Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab0GOQH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:07:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39325 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330Ab0GOQH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:07:57 -0400
Date: Thu, 15 Jul 2010 09:07:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: tanaka <tanaka_hideo@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please teach me X86 I/O port 0x61
Message-Id: <20100715090746.fdfce533.randy.dunlap@oracle.com>
In-Reply-To: <20100715150036.22283.qmail@web100113.mail.kks.yahoo.co.jp>
References: <20100715150036.22283.qmail@web100113.mail.kks.yahoo.co.jp>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C3F325B.0249:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 00:00:36 +0900 (JST) tanaka wrote:

> Dear all.
> 
> I investigate about  NMI kernel messages.
> Linux kernel read 0x61 address using inb(61h).
> 
> I search a amd opteron cpu following manuals.
> but I do not find  explanation of 0x61 address.
> 
> http://support.amd.com/us/psearch/Pages/psearch.aspx?type=2.1&product=2.1.4&contentType=Tech+Doc+Processor&ostype=&keywords=&items=20
> 
> Could you teach me a 0x61 address of X86 arch >

Hi,

IO port 0x61 (NMI Status & Control register) is not CPU-specific on x86.
It's more of a platform thing.

Intel describes it in ICH (chipset) specs, e.g., ICH7 spec,
section 10.7.1.  Please try that and see if it answers your questions.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
