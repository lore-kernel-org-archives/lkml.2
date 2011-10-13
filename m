Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1JMIgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:36:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39939 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1JMIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:36:11 -0400
Message-ID: <4E96A2F7.2000607@monstr.eu>
Date: Thu, 13 Oct 2011 10:36:07 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] [TRIVIAL] microblaze: add missing CONFIG_ prefixes
References: <1318447716.8345.3.camel@x61.thuisdomein> <alpine.LNX.2.00.1110131033360.14768@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1110131033360.14768@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 12 Oct 2011, Paul Bolle wrote:
> 
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> Entirely untested. Somehow, I don't feel too bad about that. Added the
>> maintainer and the mailinglist because this could change the behavior of
>> this code.
> 
> Yes, this might make so-far unexcercised codepaths to appear, so I'd like 
> to have maintainer's Ack before applying it. I don't have microblaze 
> cross-compiling setup.
> 
> Thanks,

Here it is:
Acked-by: Michal Simek <monstr@monstr.eu>

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
