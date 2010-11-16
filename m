Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab0KPVSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:18:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44417 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0KPVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:18:20 -0500
Date: Tue, 16 Nov 2010 13:17:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Build failure 2.6.37-rc2
Message-Id: <20101116131719.34193c59.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTinLKibXfnN2XSVE2P_x3EJancRNdi3B4YBxvL=j@mail.gmail.com>
References: <AANLkTinLKibXfnN2XSVE2P_x3EJancRNdi3B4YBxvL=j@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 09:30:53 +0200 Anca Emanuel wrote:

>   Building modules, stage 2.
>   MODPOST 2794 modules
> FATAL: arch/x86/kernel/msr.o has no symtab?
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make[1]: Leaving directory `/home/emi/linux-2.6'
> make: *** [debian/stamp/build/kernel] Error 2
> --

Tools problem?  I can't reproduce it.

Maybe post your .config file and tell us what gcc and ld versions
you are using...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
