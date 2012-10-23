Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab2JWPH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:07:26 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:26917 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2JWPHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:07:24 -0400
Message-ID: <1351004840.2552.13.camel@lorien2>
Subject: Re: [PATCH -stable] amd_iommu: attach device fails on the last pci
 device
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Greg KH <gregkh@linuxfoundation.org>, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Tue, 23 Oct 2012 09:07:20 -0600
In-Reply-To: <20121012193543.GA16600@elie.Belkin>
References: <1350059367.2643.17.camel@lorien2>
	 <20121012183828.GA16453@elie.Belkin> <1350067490.4627.8.camel@lorien2>
	 <20121012193543.GA16600@elie.Belkin>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 12:35 -0700, Jonathan Nieder wrote:
> Shuah Khan wrote:
> > On Fri, 2012-10-12 at 11:38 -0700, Jonathan Nieder wrote:
> 
> >> To save Willy time: am I correct in guessing the upstream commit you
> >> are referring to is 98fc5a693bbdda498a556654c70d1e31a186c988
> >> (x86/amd-iommu: Use get_device_id and check_device where appropriate,
> >> 2009-11-24)?
> >
> > Yes that is one.
> 
> Great, thanks for the quick confirmation.

Is this patch in the queue to be pulled into 2.6.32 tree?

Thanks,
-- Shuah

