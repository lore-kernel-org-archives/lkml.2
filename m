Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1AGAu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:50:59 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4292 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab1AGAu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:50:58 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: 2.6.37 vlans on bnx2 not functional, panic with tcpdump
From: "Michael Chan" <mchan@broadcom.com>
To: "Iain Paton" <selsinork@gmail.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1294357941.21580.2.camel@HP1>
References: <4D2634DE.2060907@gmail.com> <1294357941.21580.2.camel@HP1>
Date: Thu, 6 Jan 2011 16:46:46 -0800
Message-ID: <1294361206.21580.7.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6138BC2D3P052285453-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2011-01-06 at 15:52 -0800, Michael Chan wrote:
> On Thu, 2011-01-06 at 13:32 -0800, Iain Paton wrote:
> > Hi,
> > 
> > vlans don't appear to be functional on my HP DL380G6 with onboard bnx2
> > adapter using vanilla 2.6.37 kernel. No tagged vlan traffic 
> > is arriving at the vlan interface.
> 
> VLANs on net-next-2.6 kernel works for me on bnx2 devices.  I'll try
> 2.6.37 next.

May be you have management firmware running on your devices that can
change the behavior.  Can you provide ethtool -i eth0 on both bnx2
devices on your system?


