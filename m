Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1AZT7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:59:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36419 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1AZT7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:59:11 -0500
MIME-Version: 1.0
In-Reply-To: <20110126194301.GA13541@zod.rchland.ibm.com>
References: <1296062434-18027-1-git-send-email-grant.likely@secretlab.ca> <20110126194301.GA13541@zod.rchland.ibm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jan 2011 12:58:50 -0700
X-Google-Sender-Auth: cH7BQaMeOhCsyDn7zN2AkWA55Mo
Message-ID: <AANLkTimmHSxP32WsYL1ZXor1GuZQ6W91gcbmKOyQumK_@mail.gmail.com>
Subject: Re: [PATCH] dt: Move device tree documentation out of powerpc directory
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 12:43 PM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> On Wed, Jan 26, 2011 at 10:20:34AM -0700, Grant Likely wrote:
>>The device tree is used by more than just PowerPC.  Make the documentation
>>directory available to all.
>>
>>Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>---
>>
>>Assuming nobody has an issue with this, I'll push it out to Linus for
>>2.6.38 since it is only a documentation change.
>>
>>g.
>>
>> .../bindings}/4xx/cpm.txt                          |    0
>> .../bindings}/4xx/emac.txt                         |    0
>> .../bindings}/4xx/ndfc.txt                         |    0
>> .../bindings}/4xx/ppc440spe-adma.txt               |    0
>> .../bindings}/4xx/reboot.txt                       |    0
>
> This should probably be renamed to ...bindings}/powerpc4xx/ in that
> case.  Similarly for fsl (even more so since they have ARM parts too).

okay, I'll look at reorganizing.

>
> Also the booting-without-of.txt file is very powerpc specific.  So I
> would suggest either creating a powerpc/ directory under /bindings or
> something similar.

Actually, it isn't.  Very little of it is powerpc-specific, and after
I looked at it I decided that it still made sense to keep it in this
file and add additional sections for arm, x86, mips and microblaze
entry.

g.
