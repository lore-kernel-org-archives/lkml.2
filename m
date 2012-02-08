Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2BHRlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:41:47 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50124 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2BHRlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120208172320.GA30819@redhat.com>
References: <20120208172320.GA30819@redhat.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 8 Feb 2012 09:41:25 -0800
Message-ID: <CALSq=BaDkVraE5hRQr4gs1RT2CHEXcn35EPzcnkN78OZcoCQfg@mail.gmail.com>
Subject: Re: iwlagn: wrong command queue backtrace.
To: Dave Jones <davej@redhat.com>, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 9:23 AM, Dave Jones <davej@redhat.com> wrote:
>
> I just hit this with the iwlagn driver currently in Linus' tree.
>

AFAICT this could be a side effect of some bad QoS packet processing.
The patch (http://www.spinics.net/lists/linux-wireless/msg84213.html)
hasn't yet made it to Linus' tree, but you could cherry-pick it...

Dan
