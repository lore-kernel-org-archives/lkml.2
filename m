Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2HHGiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:38:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15568 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2HHGiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:38:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 07 Aug 2012 23:33:07 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 8 Aug 2012 12:08:10 +0530
Subject: RE: question on devm_kfree
Thread-Topic: question on devm_kfree
Thread-Index: Ac11Lvlx79APrLJiSYWzVCoSaQUXTgAAMvOw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDD254A76@BGMAIL02.nvidia.com>
References: <5021FF92.8030904@nvidia.com> <50220779.9000206@metafoo.de>
In-Reply-To: <50220779.9000206@metafoo.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Wednesday, August 08, 2012 12:00 PM
> To: Venu Byravarasu
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: question on devm_kfree
> 
> On 08/08/2012 07:56 AM, Venu Byravarasu wrote:
> > As per comments related to devm_kzalloc, memory allocated using it is
> > freed automatically.
> > However there is a function called devm_kfree, comment section of which
> > says that it is used to free memory allocated using devm_kzalloc().
> > If memory allocated by devm_kzalloc is freed automatically, what's the
> > need & significance of devm_kfree?
> >
> > Thanks,
> > Venu
> >
> 
> Hi,
> 
> Memory allocated with devm_kzalloc is freed at the end of the lifetime of the
> device it is attached to. If you for some reason want to free allocated with
> memory devm_kzalloc before that of the lifetime of the device can use
> devm_kfree.
> 
> 
> - Lars
 
Thanks Lars.
