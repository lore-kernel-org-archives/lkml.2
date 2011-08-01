Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1HAR6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1HAR6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:58:32 -0400
Subject: Re: [PATCH] libertas: prioritize usb8388_v5.bin firmware on OLPC
 machines
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>, cjb@laptop.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org
Date: Mon, 01 Aug 2011 12:17:23 -0500
In-Reply-To: <CAGq3pz75qVMuR_Hh3GKg8xK7T+_ZAW5gBZns6D6PfDYh4CF5GA@mail.gmail.com>
References: <20110731000300.5c08e95f@debxo> <20110731000521.45e48638@debxo>
	 <CAGq3pz75qVMuR_Hh3GKg8xK7T+_ZAW5gBZns6D6PfDYh4CF5GA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1312219075.6121.20.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 13:59 +0100, Daniel Drake wrote:
> On 31 July 2011 08:05, Andres Salomon <dilinger@queued.net> wrote:
> > Note: I've not tested this out yet on an XO-1.  I'll do that after some
> > feedback regarding the matching linux-firmware pull request.  This
> > should address dsd's concern about changing the loading order of the
> > firmware.
> 
> That indeed was a concern, but only until Dan Williams and Chris
> pointed out that OLPC is the only usb8388 user. With that in mind, I
> am in agreement with them that simply putting usb8388_olpc_v5.bin (or
> whatever name is chosen) at the top of the firmware loading list is
> the best option.

Yeah, patches for that would be immediately acked.

Dan

