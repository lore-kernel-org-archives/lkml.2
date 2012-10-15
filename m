Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2JORWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:22:14 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:45989
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987Ab2JORWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:22:13 -0400
Message-ID: <1350321429.7065.97.camel@rhapsody>
Subject: Re: [PATCH v4 1/2] x86, pci: Reset PCIe devices at boot time
From: Khalid Aziz <khalid@gonehiking.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, mingo@redhat.com, vgoyal@redhat.com
Date: Mon, 15 Oct 2012 11:17:09 -0600
In-Reply-To: <20121015065526.2832.90867.sendpatchset@indoh>
References: <20121015065516.2832.42378.sendpatchset@indoh>
	 <20121015065526.2832.90867.sendpatchset@indoh>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 16:00 +0900, Takao Indoh wrote:
> This patch resets PCIe devices at boot time by hot reset when
> "reset_devices" is specified.
> 
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> ---
>  arch/x86/include/asm/pci-direct.h |    1 
>  arch/x86/kernel/setup.c           |    3 
>  arch/x86/pci/early.c              |  344 ++++++++++++++++++++++++++++
>  include/linux/pci.h               |    2 
>  init/main.c                       |    4 
>  5 files changed, 352 insertions(+), 2 deletions(-)
> 


Looks good.

Reviewed-by: Khalid Aziz <khalid@gonehiking.org>

--
Khalid

