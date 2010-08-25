Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0HYPyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:54:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44142 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab0HYPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:54:50 -0400
Date: Wed, 25 Aug 2010 08:52:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Unable to compile 2.6.36-rc2 on x86_64
Message-Id: <20100825085251.5c47eebe.randy.dunlap@oracle.com>
In-Reply-To: <20100825151554.GA6763@deepthought>
References: <20100825151554.GA6763@deepthought>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 16:15:54 +0100 Ken Moffat wrote:

> Hi,
> 
>  on x86_64 using a config that worked in 2.6.35.3 plus accepting the
> default settings for new options, it fails with
> 
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `toshiba_acpi_exit':
> toshiba_acpi.c:(.text+0x1c5e07): undefined reference to
> `led_classdev_unregister'
> drivers/built-in.o: In function `toshiba_acpi_init':
> toshiba_acpi.c:(.init.text+0xa2d8): undefined reference to
> `led_classdev_register'
> make: *** [.tmp_vmlinux1] Error 1
> 
>  I don't actually need toshiba_acpi, but it seems to be built by
> default if acpi is turned on ?
> 
> Gzipped config attached.


Needs recently-merged commit c76a3e1d6c52c5cc1371f1abc7381c5715ebdf7f.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
