Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0LJVH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:07:27 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59178 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751983Ab0LJVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:07:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VaDtBotblqIiuykp7Go5K7qlsB4P/6ZbtqcqnajvNs1DFCJgs1zyUG3cmmlOBasHSi18TD2zZu7iwDVn7UOYpkhZDUtQPvzKCnhh2526l5n2bQoMJRCvPE/e8X057u4I;
Date: Fri, 10 Dec 2010 13:07:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Disable ASPM if BIOS asks us to
Message-ID: <20101210130719.6ef6cd3d@jbarnes-desktop>
In-Reply-To: <1291662056-6055-1-git-send-email-mjg@redhat.com>
References: <1291662056-6055-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Dec 2010 14:00:56 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> We currently refuse to touch the ASPM registers if the BIOS tells us that
> ASPM isn't supported. This can cause problems if the BIOS has (for any
> reason) enabled ASPM on some devices anyway. Change the code such that we
> explicitly clear ASPM if the FADT indicates that ASPM isn't supported,
> and make sure we tidy up appropriately on device removal in order to deal
> with the hotplug case. If ASPM is disabled because the BIOS doesn't hand
> over control then we won't touch the registers.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
> 

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
