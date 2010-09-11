Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0IKAOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:14:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507Ab0IKAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:14:19 -0400
Date: Fri, 10 Sep 2010 17:14:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Jones <pjones@redhat.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make efifb check that the base address is plausible
 on pci systems.
Message-Id: <20100910171406.bdb4d90d.akpm@linux-foundation.org>
In-Reply-To: <1284059809-9973-1-git-send-email-pjones@redhat.com>
References: <1284059809-9973-1-git-send-email-pjones@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Sep 2010 15:16:48 -0400
Peter Jones <pjones@redhat.com> wrote:

> Some Apple machines have identical DMI data but different memory
> configurations for the video. Given that, check that the address in our
> table is actually within the range of a PCI BAR on a VGA deivce in the
> machine.
> 
> This also fixes up the return value from set_system(), which has
> always been wrong, but never resulted in bad behavior since there's only
> ever been one matching entry in the dmi table.
> 
> This also adds me as the efifb maintainer, since I've effectively been
> acting as such for quite some time.

And what is the impact (and importance) of this patch?  Make some
people's Mac displays work, I'd be guessing?

