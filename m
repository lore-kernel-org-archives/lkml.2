Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1LNVpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:45:25 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:55764 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1LNVpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:45:22 -0500
Date: Wed, 14 Dec 2011 22:37:13 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Su Kang Yin <cantona@cantona.no-ip.org>
Cc: hayeswang <hayeswang@realtek.com>, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] r8169.c correct MSIEnable register offset
Message-ID: <20111214213713.GA2907@electric-eye.fr.zoreil.com>
References: <CABJLtPHWfRLcbzDFR0ZXe4da3jv04eDZL2CabF1FTcaadoy0xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABJLtPHWfRLcbzDFR0ZXe4da3jv04eDZL2CabF1FTcaadoy0xQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Su Kang Yin <cantona@cantona.no-ip.org> :
> correct MSIEnable (bit 5) register to Config1 (offset 0x52) instead of
> Config2 (offset 0x53)

I wonder where the inspiration for the MSIEnable bit came from.
It looks like something was confused with the Message Control word
in PCI space.

Imho you can simply remove it altogether.

-- 
Ueimor
