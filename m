Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1GOSXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:23:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53402 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1GOSXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:23:18 -0400
User-Agent: Microsoft-Entourage/12.30.0.110427
Date: Fri, 15 Jul 2011 19:23:06 +0100
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
From: Keir Fraser <keir.xen@gmail.com>
To: Jan Beulich <JBeulich@novell.com>, <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <keir@xen.org>
CC: <olaf@aepfle.de>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <CA46441A.1E019%keir.xen@gmail.com>
Thread-Topic: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
Thread-Index: AcxDHD2w9ppdL4DyWkqbCq16XCM1bw==
In-Reply-To: <4E20873F020000780007307B@nat28.tlf.novell.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/2011 18:30, "Jan Beulich" <JBeulich@novell.com> wrote:

> Actually, one more thought: What's the purpose of this hypercall if
> it is set in stone what values it ought to return? Isn't a guest using
> it (supposed to be) advertising that it can deal with the values being
> variable (and it was just overlooked so far that this doesn't only
> include varying values from boot to boot, but also migration)? Or in
> other words, if we found a need to relocate the M2P table or grow
> its static maximum size, it would be impossible to migrate guests
> from an old to a new hypervisor.

Fair point. There has to be a static fallback set of return values for old
guests.

 -- Keir


