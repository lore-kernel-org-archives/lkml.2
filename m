Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab2C2V0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:26:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11100 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465Ab2C2V0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:26:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 29 Mar 2012 14:26:11 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>
Date: Thu, 29 Mar 2012 14:26:10 -0700
Subject: RE: New Tegra branch for linux-next
Thread-Topic: New Tegra branch for linux-next
Thread-Index: Ac0N8aVZkbReDOcgRxSdPF/N2fr07QAAKo5g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17E43DC7D1@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17E43DC742@HQMAIL01.nvidia.com>
 <20120330081926.82702541e47b3d188ca8054f@canb.auug.org.au>
In-Reply-To: <20120330081926.82702541e47b3d188ca8054f@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote at Thursday, March 29, 2012 3:19 PM:
> On Thu, 29 Mar 2012 12:13:10 -0700 Stephen Warren <swarren@nvidia.com> wrote:
> >
> > Could you replace the existing Tegra branch in linux-next:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git for-next
> >
> > with the following:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git for-next
> 
> Done.
> 
> > (it currently contains v3.3-rc6 until the merge window is over)
> 
> Just confirming that it now contains a single fix patch ...

Oh yes, I looked at the wrong local pull of it. There is indeed 1 patch
there, which is targeted at 3.4.

Thanks.

-- 
nvpublic

