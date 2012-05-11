Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2EKHAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:00:31 -0400
Received: from smtprelay02.ispgateway.de ([80.67.29.24]:37939 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2EKHAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:00:30 -0400
Message-ID: <4FACB9F6.1070704@ladisch.de>
Date: Fri, 11 May 2012 09:04:22 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/9] x86, amd_nb: Export model 0x10 and later PCI id
References: <1336660229-32644-1-git-send-email-bp@amd64.org> <1336660229-32644-2-git-send-email-bp@amd64.org>
In-Reply-To: <1336660229-32644-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Add the F3 PCI id of F15h, model 0x10 to pci_ids.h and to the amd_nb
> code which generates the list of northbridges on an AMD box. Shorten
> define name while at it so that it fits into pci_ids.h.
>
> Cc: Clemens Ladisch <clemens@ladisch.de>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/amd_nb.c |    1 +
>  drivers/hwmon/k10temp.c  |    5 +----
>  include/linux/pci_ids.h  |    1 +
>  3 files changed, 3 insertions(+), 4 deletions(-)
