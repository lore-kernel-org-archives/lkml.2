Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1HZJWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:22:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41568 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754198Ab1HZJWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:22:38 -0400
X-Authenticated: #28077480
X-Provags-ID: V01U2FsdGVkX18IzngGa7wI9ocUjgUjX6GxyxfgN6WavYT5M/V9W+
	31ZjvIlLF5mkBl
From: Ralf Jung <ralfjung-e@gmx.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Date: Fri, 26 Aug 2011 11:22:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <4E56F9E5.4000005@zytor.com> <20110826064838.GB3903@sun>
In-Reply-To: <20110826064838.GB3903@sun>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261122.33304.ralfjung-e@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I rather wonder if there a way to assign a different address for the
> watchdog Bjorn referring to. I don't have such machine to test but
> seems its base address is configurable via pmio. Just curious.
That would be the watchdog in my laptop then, I guess (I'm the reporter of the 
bug mentioned by Bjorn)? I don't know much about all the inner workings, but 
if you send me patches I can tell you what they do.

Kind regards,
Ralf
