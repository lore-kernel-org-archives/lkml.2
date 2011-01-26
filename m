Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1AZPRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:17:38 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51200 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1AZPRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:17:36 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 26 Jan 2011 10:17:35 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4] smc91x: add devicetree support
In-reply-to: <1296019325-17801-1-git-send-email-thomas@wytron.com.tw>
Message-id: <alpine.LFD.2.00.1101261004560.8580@xanadu.home>
References: <20110125.194532.71125517.davem@davemloft.net>
 <1296019325-17801-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Thomas Chou wrote:

> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
> v2 specify part numbers in compat as Grant suggested.
> v3 more specific part name.
> v4 include match table only for OF as David suggested.

The smc91x driver relies on many parameters which are platform specific, 
such as the bus width capabilities, register spacing due to special bus 
wiring, interrupt signal level, LED configuration, whether or not to 
configure the chip with a wait state, etc.  Will the device tree support 
take care of those things?


Nicolas
