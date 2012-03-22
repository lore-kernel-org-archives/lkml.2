Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2CVFg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:36:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45780 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2CVFg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:36:26 -0400
Message-ID: <4F6ABA55.8080001@kernel.org>
Date: Thu, 22 Mar 2012 01:36:21 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Subject: Re: [GIT PULL] tboot: cleanups for 3.4
References: <20120319185302.GA7299@phenom.dumpdata.com>
In-Reply-To: <20120319185302.GA7299@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
Len Brown, Intel Open Source Technology Center

On 03/19/2012 02:53 PM, Konrad Rzeszutek Wilk wrote:

> Hey Peter,
> 
> Please pull in your for-v3.4 branch this branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/for-x86-for-3.4
> 
> which has two patches for v3.4. They have been acked by Rafael Wysocki
> and Joseph Cihula and posted: https://lkml.org/lkml/2012/3/10/115
> 
> The net gain of these patches is to remove the 'tboot' call within the ACPI core
> framwork and replace it with an function call where the platform drivers can
> register if they choose to. This makes it possible for platforms such as ARM, IA64
> to choose whether they want to make a call to something similar to tboot or not.
> If nothing is registered the call ends up being a nop.
> 
> 
>  arch/x86/kernel/tboot.c       |    9 ++++++---
>  drivers/acpi/acpica/hwsleep.c |   10 +++++++---
>  drivers/acpi/osl.c            |   24 ++++++++++++++++++++++++
>  include/acpi/acexcep.h        |    1 +
>  include/linux/acpi.h          |   10 ++++++++++
>  include/linux/tboot.h         |    1 -
>  6 files changed, 48 insertions(+), 7 deletions(-)
> 
> Konrad Rzeszutek Wilk (1):
>       tboot: Add return values for tboot_sleep
> 
> Tang Liang (1):
>       x86, acpi, tboot: Have a ACPI os prepare sleep instead of calling tboot_sleep.
> 


