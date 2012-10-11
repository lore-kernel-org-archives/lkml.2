Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2JKOr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:47:28 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40349 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2JKOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:47:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAJtaB1v95Z2b78cKUPYrZtriF6BuHwD2=StyhV3gGOOquNt7fw@mail.gmail.com>
References: <CAJtaB1v95Z2b78cKUPYrZtriF6BuHwD2=StyhV3gGOOquNt7fw@mail.gmail.com>
Date: Thu, 11 Oct 2012 10:47:24 -0400
Message-ID: <CAJtaB1v8Zn8kwqbhD-emey6prxDyHNMUM_9sxXFMX9FkmuiNXA@mail.gmail.com>
Subject: Re: regression in bonding driver with VLAN challenged interfaces when
 8021q module is loaded
From: Jon Stanley <jstanley@rmrf.net>
To: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:28 AM, Jon Stanley <jstanley@rmrf.net> wrote:

> This specifically affects IPoIB interfaces in a bond if you do a
> down/up cycle on the bond post-boot (during boot, the bonding module
> is loaded prior to the 8021q module, so everything is fine).

I hate replying to myself, but I've just been shown an instance where
it fails to come up at boot. The configuration involves tagged
Ethernet interfaces *and* IPoIB in a bond (obviously with no VLAN's on
the IPoIB bond), I probably wasn't clear on that in my original mail.
