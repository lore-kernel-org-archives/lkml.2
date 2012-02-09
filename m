Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2BIHTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:19:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42125 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2BIHTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:19:41 -0500
MIME-Version: 1.0
In-Reply-To: <CALSq=BaDkVraE5hRQr4gs1RT2CHEXcn35EPzcnkN78OZcoCQfg@mail.gmail.com>
References: <20120208172320.GA30819@redhat.com>
	<CALSq=BaDkVraE5hRQr4gs1RT2CHEXcn35EPzcnkN78OZcoCQfg@mail.gmail.com>
Date: Thu, 9 Feb 2012 09:19:39 +0200
Message-ID: <CANUX_P01gBqCX1XNydm=pZQMmSgUsg1D4uUx9ngeFdY8YoALDA@mail.gmail.com>
Subject: Re: iwlagn: wrong command queue backtrace.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Dave Jones <davej@redhat.com>, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> I just hit this with the iwlagn driver currently in Linus' tree.
>>
>
> AFAICT this could be a side effect of some bad QoS packet processing.
> The patch (http://www.spinics.net/lists/linux-wireless/msg84213.html)
> hasn't yet made it to Linus' tree, but you could cherry-pick it...
>

Although I would like to believe it is related, I don't think it is.
The question is how reproducible this bug is.

This badly looks like your report from around 3 months:

https://lkml.org/lkml/2011/11/25/60
