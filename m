Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2G0Pjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:39:41 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:45033 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2G0Pjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:39:39 -0400
Date: Fri, 27 Jul 2012 17:25:42 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: sandeep@freescale.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        galak@kernel.crashing.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [2/3][PATCH][v2] TDM Framework
Message-ID: <20120727152542.GB1613@electric-eye.fr.zoreil.com>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sandeep@freescale.com <sandeep@freescale.com> :
[...]
> The main functions of this Framework are:
>  - provides interface to TDM clients to access TDM functionalities.
>  - provides standard interface for TDM drivers to hook with the framework.
>  - handles various data handling stuff and buffer management.
> 
> In future this Framework will be extended to provide Interface for Line control devices also. For example SLIC, E1/T1 Framers etc.
> 
> Presently the framework supports only Single Port channelised mode.
> Also the configurability options are limited which will be extended later on.
> Only kernel mode TDM clients are supported currently. Support for User mode clients will be added later.

1. You should send some kernel mode TDM clients. Without those the framework
   is pretty useless.

2. It would probably make sense to Cc: netdev and serial. There may be
   some kernel client network integration from the start.

3. Where is the userspace configuration interface ?

[...]
> Based on: git://git.am.freescale.net/gitolite/mirrors/galak-powerpc.git

$ git clone git://git.am.freescale.net/gitolite/mirrors/galak-powerpc.git
Cloning into 'galak-powerpc'...
fatal: Unable to look up git.am.freescale.net (port 9418) (No address associated with hostname)

-- 
Ueimor
