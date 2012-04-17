Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2DQQDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:03:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43374 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2DQQDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <201204171153.04489.gene.heskett@gmail.com>
References: <20120411163849.GE4794@alberich.amd.com> <4F8D7A0A.4080404@linux.vnet.ibm.com>
 <20120417145002.GA11221@aftab> <201204171153.04489.gene.heskett@gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 17 Apr 2012 18:02:54 +0200
Message-ID: <CAPXgP12_k4D-r=HQy3zidHhMP8ygMsT4J5Q+-h0CE3k_vpsazA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        tigran@aivazian.fsnet.co.uk, hpa@zytor.com, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/17 Gene Heskett <gene.heskett@gmail.com>:

> I do not think the above has anything to do with the current version
> shipping in some distro's, which is trying to find the intel code on
> kernels >2.6.39 when running on AMD stuff, so that script in /etc/init.d
> needs attention too.  I have nuked about half of that script in my local
> copy so that it does install AMD code on AMD processors.  The errors I was
> seeing were only the lack of its ability to find the Intel code and does
> not generate any output resembling the above.

Just a note: the intel microcode is loaded by a kernel-initiated
firmware request these days. There is no (broken) init script on
recent systems, to (rather mindlessly) fiddle around in userspace with
kernel internals.

Kay
