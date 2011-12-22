Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1LVBtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:49:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:48400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab1LVBs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:48:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="89148278"
Subject: Re: [PATCH -v8] x86: Disable x2apic if nox2apic is specified or
 intr-remap can not be enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 17:54:00 -0800
In-Reply-To: <CAE9FiQXodjK=GRO2ut4fGS=wXBc59+rov-BVKXhDGK8vJVBHhQ@mail.gmail.com>
References: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
	 <1324363882.2286.23.camel@sbsiddha-mobl2>
	 <CAE9FiQU__U0CCiyzF9kDC1Z=PUEoTe1Jm-M97EbCO440Vm9P_A@mail.gmail.com>
	 <CAE9FiQXodjK=GRO2ut4fGS=wXBc59+rov-BVKXhDGK8vJVBHhQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324518840.21294.14.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 18:24 -0800, Yinghai Lu wrote:
> put your updated version as v9.
> 
> like to let ingo or hpa or thomas to decide v8 or v9 to be used.
> 
>         Changes:
>                  1. clear x2apic cpu features
>                  2. disable x2apic later instead of check_x2apic()

Yinghai, It is not the question of just cleanup. changing the apic mode
has to follow some sequence.

Anyways, I have done all the changes and other minor cleanups. Also
split up your patch into multiple patches and posted it now.

Please let me know if you see any issue.

thanks,
suresh



