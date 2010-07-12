Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0GLSik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:38:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34065 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0GLSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:38:39 -0400
Date: Mon, 12 Jul 2010 11:37:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Lee Jones <ljkenny@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linuxfoundation.org
Subject: Re: [Upstream] Stop ARM boards crashing with CUPS is loaded
Message-Id: <20100712113743.c95d49dc.randy.dunlap@oracle.com>
In-Reply-To: <4C3B071D.10505@gmail.com>
References: <4C3B071D.10505@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C3B6106.0099:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 13:14:21 +0100 Lee Jones wrote:

> Please find attached a patch which rectifies the following bug.
> 
> When CUPS loads, it tries to load several drivers that it may need.
> When one of these drivers, specifically parport_pc is loaded on ARM
> based systems, it causes a segmentation fault as the address is not
> writable on non-PC based architectures. This code prevents this
> driver from being compiled on said architectures.


Do you have any specific information on where the segfault occurs?

and please read <kernel-source-tree>/Documentation/SubmittingPatches
and possibly Documentation/email-clients.txt .

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
