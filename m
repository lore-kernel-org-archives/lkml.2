Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2JEGug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:50:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39627 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2JEGue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:50:34 -0400
Message-ID: <506E771B.2080102@monstr.eu>
Date: Fri, 05 Oct 2012 07:58:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 08/11] net: ll_temac: Do not use fixed mtu size
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>  <1349374497-9540-8-git-send-email-monstr@monstr.eu> <1349378563.2817.27.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1349378563.2817.27.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 09:22 PM, Ben Hutchings wrote:
> On Thu, 2012-10-04 at 20:14 +0200, Michal Simek wrote:
>> Use max mtu instead.
> [...]
>
> MTU does not include the Ethernet header so I have no idea how this is
> expected to work...

Right. This is wrong fix. It should be the same as is in axienet.
There is max_frm_size used which is mtu+header+tailer.
I will fix it.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
