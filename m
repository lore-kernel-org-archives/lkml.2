Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1FPJrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:47:41 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:19190
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033Ab1FPJrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:47:40 -0400
X-IronPort-AV: E=Sophos;i="4.65,374,1304287200"; 
   d="scan'208";a="101371546"
Date: Thu, 16 Jun 2011 11:47:37 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC] Add Arm cpu topology definition
Message-ID: <20110616094737.GB5583@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com> <20110616085547.GH4935@const.famille.thibault.fr> <BANLkTinxz1T7uPAS0u=gth3hAh+SFQkTQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinxz1T7uPAS0u=gth3hAh+SFQkTQQ@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Guittot, le Thu 16 Jun 2011 11:44:30 +0200, a écrit :
> The output of hwloc-gather-topology is :
> 
> Machine (phys=0 local=280840KB total=280840KB)
>   Socket #0 (phys=3)
>     Core #0 (phys=0)
>       PU #0 (phys=0)
>     Core #1 (phys=1)
>       PU #1 (phys=1)
> depth 0:        1 Machine (type #1)
>  depth 1:       1 Socket (type #3)
>   depth 2:      2 Cores (type #5)
>    depth 3:     2 PUs (type #6)
> Topology not from this system
> 
> let me know if it's what you want

This looks good for a bicore socket, yes.  Could you send me the tarball
it created, so we can include it in the hwloc testsuite?

Do you have a example with smt cores?

Samuel
