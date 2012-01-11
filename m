Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab2AKVYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:24:02 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60758 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:24:00 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6tYrnM6MrFS3hmqRiiKR1G_uECKhp2bgV49sW7soapuQw@mail.gmail.com>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
 <4F0E017B.9060602@xenotime.net> <CACxGe6tYrnM6MrFS3hmqRiiKR1G_uECKhp2bgV49sW7soapuQw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Jan 2012 14:23:38 -0700
X-Google-Sender-Auth: vuoE1xLuqatBwhBelSl3VrcR4a4
Message-ID: <CACxGe6v0YcxsmidFhe=s3EiDrYDoYBZLyk1MZjyg8uXRFGSvoQ@mail.gmail.com>
Subject: Re: [RFC 0/14] Finish up irq_domain generalization
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 1:50 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Jan 11, 2012 at 2:39 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 01/11/2012 12:22 PM, Grant Likely wrote:
>>> Here are the patches that I've been working on to finish up the creation
>>> of the generic irq_domain infrastructure.
>>
>> Does this fix the linux-next build problems that I have reported?
>>
>> https://lkml.org/lkml/2012/1/9/318
>
> IIRC, that was solved and a fix merged.  The problem was a driver
> selecting CONFIG_IRQ_DOMAIN when it must not do so.  I'm build testing
> with that randconfig now to make sure.

Yes, doing oldconfig on that sample no longer has CONFIG_IRQ_DOMAIN
selected, so it looks okay.

g.
