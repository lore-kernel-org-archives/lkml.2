Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab2JLTfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:35:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59715 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2JLTfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:35:53 -0400
Date: Fri, 12 Oct 2012 12:35:43 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Greg KH <gregkh@linuxfoundation.org>, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: [PATCH -stable] amd_iommu: attach device fails on the last pci
 device
Message-ID: <20121012193543.GA16600@elie.Belkin>
References: <1350059367.2643.17.camel@lorien2>
 <20121012183828.GA16453@elie.Belkin>
 <1350067490.4627.8.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350067490.4627.8.camel@lorien2>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan wrote:
> On Fri, 2012-10-12 at 11:38 -0700, Jonathan Nieder wrote:

>> To save Willy time: am I correct in guessing the upstream commit you
>> are referring to is 98fc5a693bbdda498a556654c70d1e31a186c988
>> (x86/amd-iommu: Use get_device_id and check_device where appropriate,
>> 2009-11-24)?
>
> Yes that is one.

Great, thanks for the quick confirmation.

Ciao,
Jonathan
