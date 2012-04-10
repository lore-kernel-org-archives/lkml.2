Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2DJSJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:09:53 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:45316 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2DJSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:09:52 -0400
Message-ID: <4F84776D.9070608@meetinghouse.net>
Date: Tue, 10 Apr 2012 14:09:49 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
References: <4F8302B4.8040901@meetinghouse.net> <20120409155155.GA22974@srcf.ucam.org> <4F831BD0.3010707@meetinghouse.net> <20120409173223.GA25717@srcf.ucam.org> <4F83231A.8040005@meetinghouse.net> <20120409180711.GA26277@srcf.ucam.org> <4F843D9B.3010601@meetinghouse.net> <20120410142213.GA13294@srcf.ucam.org> <4F846D53.10409@meetinghouse.net> <20120410174423.GA19583@srcf.ucam.org>
In-Reply-To: <20120410174423.GA19583@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Apr 10, 2012 at 01:26:43PM -0400, Miles Fidelman wrote:
>> For what it's worth, creating a path for X86_64 mode to reboot
>> through the bios seems like
>> a good thing to put on the wish list.
> Not really - it's far more attractive to figure out how our behaviour is
> differing from Windows and change it to match. I'll see what I can find
> out about this machine.

Well.. keep in mind that that this particular machine has never run 
windows,
so I don't know if windows can reboot it either.

I expect it's like that long
laundry list of Dell servers that are in the quirks code - they all seem to
reboot via the bios when running in 32-bit mode.  I wonder what they
do when running in 64-bit mode (at least some of them are amd64 compatible).

Miles


-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra


