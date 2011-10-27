Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab1J0PBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:01:25 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:40240 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1J0PBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:01:23 -0400
X-IronPort-AV: E=Sophos;i="4.69,413,1315180800"; 
   d="scan'208";a="8623576"
Date: Thu, 27 Oct 2011 16:01:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
In-Reply-To: <4EA96BEA.7060004@oracle.com>
Message-ID: <alpine.DEB.2.00.1110271600000.3519@kaball-desktop>
References: <4E8C40A8.6080205@oracle.com> <alpine.DEB.2.00.1110061137120.3519@kaball-desktop> <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com> <alpine.DEB.2.00.1110061711290.3519@kaball-desktop> <4E92DEC1.5050806@oracle.com>
 <alpine.DEB.2.00.1110131525320.3519@kaball-desktop> <4E9D8495.4010105@oracle.com> <alpine.DEB.2.00.1110271411450.3519@kaball-desktop> <4EA96BEA.7060004@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011, Ajaykumar Hotchandani wrote:
> > BTW I am OK with your patch.
> 
> Should we revert 47e9037ac16637cd7f12b8790ea7ce6680e42168 (your changes 
> in register_slot() )
> I think, after this change, it's not needed. Or, am I missing some scenario?
> 

I think you are right, 47e9037ac16637cd7f12b8790ea7ce6680e42168 is not
needed anymore, so I am OK with reverting it.
