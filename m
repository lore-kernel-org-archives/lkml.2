Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1IKVSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 17:18:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39483
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab1IKVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 17:18:04 -0400
Message-ID: <4E6D2588.3010009@infradead.org>
Date: Sun, 11 Sep 2011 14:18:00 -0700
From: Geoff Levand <geoff@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Christian Gmeiner <christian.gmeiner@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux as Bootloader
References: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
In-Reply-To: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
X-Enigmail-Version: 1.1.2
OpenPGP: id=2E141B16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On 09/05/2011 01:24 AM, Christian Gmeiner wrote:
> I am using the linux kernel in combination with busybox and a separate
> bootloader app to
> startup a x86 based embedded device.

Just FYI, Petitboot, a kexec base bootloader, does the same
thing as what you have done.

I'm now working on adding a twin GUI program and an x86 OpenWRT build.

Current info is here:

  http://www.kernel.org/pub/linux/kernel/people/geoff/petitboot/
  http://git.kernel.org/?p=linux/kernel/git/geoff/petitboot.git

Some old info is here:

  http://www.kernel.org/pub/linux/kernel/people/geoff/cell/ps3-petitboot/
  http://ozlabs.org/~jk/projects/petitboot/

-Geoff
