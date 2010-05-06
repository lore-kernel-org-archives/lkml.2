Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0EFPHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:07:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62982 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0EFPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:07:19 -0400
Date: Thu, 6 May 2010 08:05:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-pm@lists.linux-foundation.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for May 6 (acpi: PM=n)
Message-Id: <20100506080538.b566f50e.randy.dunlap@oracle.com>
In-Reply-To: <20100506151502.f97afe54.sfr@canb.auug.org.au>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BE2DAFD.01AD:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 15:15:02 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100505:


When CONFIG_PM is not set:

drivers/built-in.o: In function `acpi_init':
bus.c:(.init.text+0x2d84): undefined reference to `pm_flags'
bus.c:(.init.text+0x2d91): undefined reference to `pm_flags'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
