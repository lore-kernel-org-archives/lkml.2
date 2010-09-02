Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab0IBFYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:24:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36249 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0IBFYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:24:48 -0400
Message-ID: <4C7F351A.9010406@monstr.eu>
Date: Thu, 02 Sep 2010 07:24:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, gregkh@suse.de,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH] serial: uartlite: Remove obscure loop from ulite_get_poll_char
References: <1282740904-1244-1-git-send-email-monstr@monstr.eu> <1282740904-1244-2-git-send-email-monstr@monstr.eu> <20100902020055.GE5117@kroah.com>
In-Reply-To: <20100902020055.GE5117@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Aug 25, 2010 at 02:55:04PM +0200, Michal Simek wrote:
>> The previous patch
>> "serial: Add CONSOLE_POLL support for uartlite"
>> (sha1 id 52ea4a7ef12f286bd68d13a93daaa688f56a1e14)
>> contained obcure loop in ulite_get_poll_char function.
> 
> I've merged this with the original patch so as to not have a problem.


Thanks and sorry for the problem,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
