Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab2GLHpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:45:45 -0400
Received: from Mailrelay020.isp.belgacom.be ([195.238.6.95]:51520 "EHLO
	mailrelay020.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757130Ab2GLHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:45:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFAGB//k9XQD44/2dsb2JhbABFtB2DWIEIgiABAQVWIgEQCxgJFg8JAwIBAgEnHgYNAQcBAYgNvXGLQIV8A5sQg1CGYIJh
Message-ID: <4FFE804A.8070205@computer.org>
Date: Thu, 12 Jul 2012 09:44:10 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <1341960205-56738-2-git-send-email-johnstul@us.ibm.com> <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos> <1342011904.3462.152.camel@twins> <alpine.LFD.2.02.1207111539060.32033@ionos> <4FFDAE1D.3050008@us.ibm.com>
In-Reply-To: <4FFDAE1D.3050008@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 06:47 PM, John Stultz wrote:
> I'll see if my worry is unfounded, but it might be a bit too clever for rare events.

Full ACK.

There is an unfortunate history of critical-to-moderately-serious bugs in
the leap second handling, so I submit that what is needed is a simple,
obviously-correct and robust mechanism. Robust statically, but also in the
face of code churn because these code paths are exercised so rarely out in
the wild.

Just my opinion, FWIW.

Jan
