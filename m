Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab2JLSio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:38:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60763 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2JLSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:38:38 -0400
Date: Fri, 12 Oct 2012 11:38:28 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Greg KH <gregkh@linuxfoundation.org>, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: [PATCH -stable] amd_iommu: attach device fails on the last pci
 device
Message-ID: <20121012183828.GA16453@elie.Belkin>
References: <1350059367.2643.17.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350059367.2643.17.camel@lorien2>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan wrote:

> This bug is in linux-2.6.32 and an equivalent fix in linux-2.6.33 and has been
> carried forward to later kernels and is in the upstream kernel. This equivalent
> fix includes restructuring and consolidating device checks into a routine
> check_device(). Instead of back-porting all of that work, spot-fixed the bug in
> amd_iommu_attach_device() for linux-2.6.32.

To save Willy time: am I correct in guessing the upstream commit you
are referring to is 98fc5a693bbdda498a556654c70d1e31a186c988
(x86/amd-iommu: Use get_device_id and check_device where appropriate,
2009-11-24)?

Thanks,
Jonathan
