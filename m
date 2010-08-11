Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab0HKXyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:54:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47460 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0HKXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:54:34 -0400
Date: Wed, 11 Aug 2010 16:54:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pistis Valentino <vale.pistis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems Compile Misc Module Example
Message-Id: <20100811165403.6713d206.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimGwbP8_fachx9pwTyX1wZxxT1iGrKziWMmxunL@mail.gmail.com>
References: <AANLkTimGwbP8_fachx9pwTyX1wZxxT1iGrKziWMmxunL@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 01:46:27 +0200 Pistis Valentino wrote:

> Hello everyone,
> 
> I'm studying how to build kernel modules.
> Right now I have found some strange errors and nothing solutions in the web.
> 
> I compiled my kernel module "driver_ase" whose files are driver_ase.h,
> driver_ase.c.
> No errors in compilation, the module is also loaded correctly.
> 
> I wrote a small service "service_ase.c" using the kernel module that I created.
> I found a lot of errors.
> the only explanation IMO is that the directory has been renamed  from
> "/usr/src/linux-2.6.34.2/include/asm" in
> "/usr/src/linux-2.6.34.2/include/asm-generic", the errors make me
> think that some header file has not yet updated.
> 
> You may like this or something wrong?
> 
> Could you help me please?
> 
> I'm using Debian Sidux with 2.6.34.2 kernel compiled.
> 
> In the bottom of the mail has the source codes, and the error.
> It is a bit long error message, sorry!

You need a minimal Makefile.
Please see Documentation/kbuild/modules.txt, section 2. How to build external modules.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
