Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105Ab1JFQFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:05:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51833 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965089Ab1JFQFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:05:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110061137120.3519@kaball-desktop>
References: <4E8C40A8.6080205@oracle.com>
	<alpine.DEB.2.00.1110061137120.3519@kaball-desktop>
Date: Thu, 6 Oct 2011 09:05:47 -0700
Message-ID: <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 3:39 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>
> I had the same issue and sent a patch a while ago to fix it, adding
>
> current_state = PCI_D0 in acpiphp_glue.c:register_slot
>
> it is strange that this does not work for you:
>
> http://marc.info/?l=linux-kernel&m=129891002722845&w=2

So guest os has to load acpiphp instead of pciehp?

Yinghai
