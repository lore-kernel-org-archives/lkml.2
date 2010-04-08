Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0DHQZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:25:55 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:54712 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932896Ab0DHQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:25:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iC+9MxYk1KibHD8USlR1SVXMT7+P35jCD/VzvHmfo0vr4m+/fil2foGPw+eBraOd9IpJkS2b/gMnaRa1ezeN44rIq3ODCLeb1xbkTWciDeTqIIvS9oVHj7CQQcxZC1V0;
Date: Thu, 8 Apr 2010 09:25:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86/PCI: ignore Consumer/Producer bit in ACPI window
 descriptions
Message-ID: <20100408092555.7933716a@virtuousgeek.org>
In-Reply-To: <20100406192408.14676.17106.stgit@bob.kio>
References: <20100406192408.14676.17106.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Apr 2010 13:24:08 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> ACPI Address Space Descriptors (used in _CRS) have a Consumer/Producer
> bit that is supposed to distinguish regions that are consumed directly
> by a device from those that are forwarded ("produced") by a bridge.
> But BIOSes have apparently not used this consistently, and Windows
> seems to ignore it, so I think Linux should ignore it as well.
> 
> I can't point to any of these supposed broken BIOSes, but since we
> now rely on _CRS by default, I think it's safer to ignore this bit
> from the start.
> 
> Here are details of my experiments with how Windows handles it:
>     https://bugzilla.kernel.org/show_bug.cgi?id=15701
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
