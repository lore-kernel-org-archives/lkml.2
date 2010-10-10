Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0JJXee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 19:34:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0JJXed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 19:34:33 -0400
Message-ID: <4CB24D7D.1060309@monstr.eu>
Date: Mon, 11 Oct 2010 09:34:21 +1000
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: Microblaze little-endian port + driver changes
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu> <AANLkTinTgO_kk=gcd50UQnwsm47fwyOX3BbGhJ1pPxUP@mail.gmail.com>
In-Reply-To: <AANLkTinTgO_kk=gcd50UQnwsm47fwyOX3BbGhJ1pPxUP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Tue, Sep 28, 2010 at 11:52 PM, Michal Simek <monstr@monstr.eu> wrote:
>> Hi everybody,
>>
>> here is the first bunch of patches which is necessary to apply
>> to get microblaze little-endian AXI version work.
>>
>> All patches are placed in microblaze-next branch and they are also
>> merged to linux-next branch.
>>
>> Grant: I would like to ask you if you can please take a look
>> at little-endian driver changes.
> 
> [cc'ing sfr re: pending linux-next merge conflict]
> 
> Hi Michal,
> 
> Can you please remove the following patches from your linux-next branch:
> 
> of: GPIO: Fix OF probing on little-endian systems
> of: MTD: Fix OF probing on little-endian systems
> of: Fix uart16550 initialization on little-endian systems

Removed from microblaze-next branch.

Regards,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
