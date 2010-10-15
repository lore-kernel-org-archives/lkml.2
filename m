Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0JOUKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:10:49 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:56204 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756918Ab0JOUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Nq3ZVRBOf1odsVcKBTDbZsSZBm+DWBd5FA03VqbCcc0U5UimRH5E2EaAXsBJd+142udZ6RbNZuSdgfZA2eF/i9e0y8VYJddF1EweJ/Yoi1fQhe56dwyH/aMIZoaWKdkX;
Date: Fri, 15 Oct 2010 13:10:28 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 5/5] pci: Add support for polling PME state on suspended
 legacy PCI devices
Message-ID: <20101015131028.7fffba40@jbarnes-desktop>
In-Reply-To: <1286216549-5438-6-git-send-email-mjg@redhat.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
	<1286216549-5438-6-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Oct 2010 14:22:29 -0400
Matthew Garrett <mjg@redhat.com> wrote:

> Not all hardware vendors hook up the PME line for legacy PCI devices,
> meaning that wakeup events get lost. The only way around this is to poll
> the devices to see if their state has changed, so add support for doing
> that on legacy PCI devices that aren't part of the core chipset.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/pci/pci.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 77 insertions(+), 0 deletions(-)

Yuck, polling.  But I guess we don't have an alternative short of
rewiring all the cheap platforms out there!

So, applied.

-- 
Jesse Barnes, Intel Open Source Technology Center
