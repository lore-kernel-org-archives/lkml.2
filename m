Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1HJTJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:09:25 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:43172 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab1HJTJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:09:24 -0400
Date: Wed, 10 Aug 2011 15:09:19 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
        mjg@redhat.com, platform-driver-x86@vger.kernel.org
Subject: Re: [RESEND][PATCH 0/5] Support for the TS-5500 board
Message-ID: <20110810150919.39519e62@v0nbox>
In-Reply-To: <1312986047.2989.47.camel@i7.infradead.org>
References: <1311887450-22235-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110809233208.1a71122e@lenov0n>
 <4E421CD8.3090606@canonical.com>
 <CAHR064hamS0gHqQR5a5UAanN89CzzW94sjW6SB3=8MAcf6pkMg@mail.gmail.com>
 <20110810100629.715c3bb7@v0nbox>
 <1312986047.2989.47.camel@i7.infradead.org>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 15:20:46 +0100,
David Woodhouse <dwmw2@infradead.org> wrote:
> Just expose these devices in the device-tree. You shouldn't *need* a
> new MTD device driver; physmap_of should be just fine.

I didn't write a new MTD device driver, but just moved the already
existing one to the ts5500 platform directory. The point is that my
TS-5500 doesn't have this flash, so I couldn't try. The fifth patch
from this set could just be ignored.

> If your bootloader doesn't pass one, your platform-specific code
> should just register its own device-tree blob during early boot. And
> your device drivers should just match against the devices therein.

I'm a bit confused with what should be done for the support for an
embedded platform (X86-based) like this TS-5500. Is the actual code
hierarchy OK? What is the impact of adding a device-tree to this code?

Thanks,
Vivien.
