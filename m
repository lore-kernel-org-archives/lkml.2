Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0KEKAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 06:00:00 -0400
Received: from omta01-pub.suddenlink.net ([208.180.40.73]:56922 "EHLO
	omta01.suddenlink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0KEJ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:59:58 -0400
Message-ID: <4CD3D57C.2000002@suddenlinkmail.com>
Date: Fri, 05 Nov 2010 04:59:24 -0500
From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Organization: Rankin Law Firm, PLLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: kernel <linux-kernel@vger.kernel.org>
Subject: Re: Upgrade to recent 2.6.35 & 2.6.36 kernel causing boot failure
 with nv dmraid
References: <4CD24A64.3080503@suddenlinkmail.com>
In-Reply-To: <4CD24A64.3080503@suddenlinkmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=Xa+JGUFQpioGoa33UcuxxNHYUG6p9xnFTEn5lEDqSS4= c=1 sm=0 a=Wn5zFxASGYcA:10 a=8nJEP1OIZ-IA:10 a=MIr4VqlunDGjLjJT3DwA:9 a=Y7t4ZAoOk_kGfZhqK0MA:7 a=O0I3l7JPDTwdBw-Jb970OEJrS7cA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 12:53 AM, David C. Rankin wrote:
<big snip>
> something got broke with the way the kernel inits the dmraid arrays resulting in
> grub thinking it is reading beyond some partition boundary or a corrupt
> partition table. Neither are correct, because simply booting an older kernel
> works fine.

Anybody have even a guess on this one? I guarantee you, your guess will be much
appreciated. (see the original post for details) Thanks.

Also, if this post isn't appropriate for the list, I apologize. I was referred
here by the Arch Linux devs to see if I could find out what may be causing the
boot failures.

As always, any help is much appreciated.

-- 
David C. Rankin, J.D.,P.E.
