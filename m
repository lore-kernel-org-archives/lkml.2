Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0IFMAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:00:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0IFMAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:00:09 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Mon, 6 Sep 2010 14:00:05 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: discuss@lesswatts.org, linux-pm@lists.linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com> <201009061243.00479.trenn@suse.de> <AANLkTik8_ixOcFy=c4hPZknyUqPYB+2hzQTNK9wVok4q@mail.gmail.com>
In-Reply-To: <AANLkTik8_ixOcFy=c4hPZknyUqPYB+2hzQTNK9wVok4q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009061400.05637.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 September 2010 13:27:13 Jean Pihet wrote:
> On Mon, Sep 6, 2010 at 12:42 PM, Thomas Renninger <trenn@suse.de> wrote:
...
> In order to reach an efficient low power mode you
> need to ensure that all clocks in a clock domain are idled or cut off
> (automatically by the HW or with the intervention of SW drivers).
> 
> The HW complexity requires the tracing of all those clocks/power
> states, that is why new events are proposed.
Hm, but if the HW can switch clocks behind your back, how do you
realize that to throw a perf clock power event then?
Theoretically you need to poll to keep track of HW switching the
clocks?

    Thomas
