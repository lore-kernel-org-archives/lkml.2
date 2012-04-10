Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2DJR0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:26:48 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:36767 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2DJR0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:26:47 -0400
Message-ID: <4F846D53.10409@meetinghouse.net>
Date: Tue, 10 Apr 2012 13:26:43 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
References: <4F8302B4.8040901@meetinghouse.net> <20120409155155.GA22974@srcf.ucam.org> <4F831BD0.3010707@meetinghouse.net> <20120409173223.GA25717@srcf.ucam.org> <4F83231A.8040005@meetinghouse.net> <20120409180711.GA26277@srcf.ucam.org> <4F843D9B.3010601@meetinghouse.net> <20120410142213.GA13294@srcf.ucam.org>
In-Reply-To: <20120410142213.GA13294@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> The default behaviour is now to use the ACPI reboot vector, and the
> behaviour was tweaked somewhat to make it work better with a variety of
> machines. If 3.3 doesn't work then we've got a problem, but I could
> absolutely believe that 2.6.32 would fail to work.
>
Interesting.  The comments still indicate that kbd is the default vector.

In any case:
- just booted with a gentoo liveCD (3.3.0 kernel)
- tried the default reboot - hangs (last console message: "Remounting / 
read only ..")
- tried with reboot=a - hangs (same last console message)

For what it's worth, creating a path for X86_64 mode to reboot through 
the bios seems like
a good thing to put on the wish list.






-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra


