Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0HCJxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:53:01 -0400
Received: from daytona.panasas.com ([67.152.220.89]:56611 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755145Ab0HCJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:53:00 -0400
Message-ID: <4C57E6F9.6080104@panasas.com>
Date: Tue, 03 Aug 2010 12:52:57 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: hacklu <embedway.linux@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how about KBUILD_MODNAME
References: <201008031037022524247@gmail.com> <201008031511572638256@gmail.com>
In-Reply-To: <201008031511572638256@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2010 09:52:59.0147 (UTC) FILETIME=[A7A77DB0:01CB32F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 10:11 AM, hacklu wrote:
> 
> I don't understand the macro KBUILD_MODNAME .
> when I compile a  driver program. It returns me "linux/pci.h:655: error: 'KBUILD_MODNAME' undeclared (first use in this function) "
> 
> In the makefile I had used the "-D" options
> 
> thanks a lot
> 
> 2010-08-03 
> 
> hacklu 
> 

The KBUILD_MODNAME fails to be set when there are two drivers built from the same
directory. There are many directories in the source tree with more then one driver
but they don't use the pr_debug macro.

Cheers
Boaz
