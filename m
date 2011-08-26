Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1HZJxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:53:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46063 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752803Ab1HZJxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:53:32 -0400
X-Authenticated: #28077480
X-Provags-ID: V01U2FsdGVkX18slw9UIi0sAxapsPu1JFsST8s1VbTKE8LBz0vN9B
	ReumtAXCyZDFVZ
From: Ralf Jung <ralfjung-e@gmx.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Date: Fri, 26 Aug 2011 11:53:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <201108261122.33304.ralfjung-e@gmx.de> <20110826093917.GE3903@sun>
In-Reply-To: <20110826093917.GE3903@sun>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261153.21103.ralfjung-e@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> Hi Ralf, I can't put that risk on you. Hell knows how it will react
> on such reprogramming (which is seems rather a bios duty than kernel).
Oh, we are talking about that kind of problems? It's my main (and only) work 
laptop, so... thanks for the warning ;-)

Kind regards,
Ralf
