Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2DSDQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:16:25 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:31365 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2DSDQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:16:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLQEBBCNVARALGgIFFgsCAgkDAgECAUUGDQEHAQG0JIoYgS+OE4EYBKkl
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="175225562"
Message-ID: <4F8F8385.4030603@teksavvy.com>
Date: Wed, 18 Apr 2012 23:16:21 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <4F8C6E4E.1000205@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com> <4F8F243B.70906@fold.natur.cuni.cz> <CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com> <4F8F4655.9000004@fold.natur.cuni.cz> <CAE9FiQWhbXPnxCAtsgL4FYqTZgqzosSdzEJCW7-11ooDNY2g8w@mail.gmail.com>
In-Reply-To: <CAE9FiQWhbXPnxCAtsgL4FYqTZgqzosSdzEJCW7-11ooDNY2g8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-18 09:57 PM, Yinghai Lu wrote:
..
> looks your BIOS does not support acpiphp.
> 
> Maybe you have to stay with
> 
> echo 1  > .../pcie_link_disable
> echo 0  > .../pcie_link_disable
> 
> after removal every time.


Did it work with earlier kernels?
If so, then that's breakage, and requiring random users
to discover mysterious incantations to keep their hardware
working after a kernel upgrade is totally unacceptable.

