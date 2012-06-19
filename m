Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2FSGvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:51:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57663 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab2FSGvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:51:06 -0400
Message-ID: <4FE02155.2010505@monstr.eu>
Date: Tue, 19 Jun 2012 08:51:01 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jun 4
References: <20120604154053.31c23de0a68defd4a9f773fc@canb.auug.org.au>
In-Reply-To: <20120604154053.31c23de0a68defd4a9f773fc@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 07:40 AM, Stephen Rothwell wrote:
> Hi all,
>
> Changes since 20120601:
>
> New tree: leds

Haven't tracked which branch contains it but there are two new patches
for Microblaze where at least one is wrong (compilation failure).
(Firstly merged Jun 4).
Based on that I think that these changes are not even tested on hw.

microblaze: fix the horror with restarts of sigreturn()
microblaze: fix handling of multiple pending signals

Al: Can you please give me some information about?
They should definitely go through my tree and has to be tested.
Please remove them from your branch which is merged to linux-next and send them as standard patches
to LKML and CC me.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
