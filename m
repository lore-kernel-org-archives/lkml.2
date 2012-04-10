Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2DJRob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:44:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53692 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2DJRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:44:30 -0400
Date: Tue, 10 Apr 2012 18:44:23 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
Message-ID: <20120410174423.GA19583@srcf.ucam.org>
References: <4F8302B4.8040901@meetinghouse.net>
 <20120409155155.GA22974@srcf.ucam.org>
 <4F831BD0.3010707@meetinghouse.net>
 <20120409173223.GA25717@srcf.ucam.org>
 <4F83231A.8040005@meetinghouse.net>
 <20120409180711.GA26277@srcf.ucam.org>
 <4F843D9B.3010601@meetinghouse.net>
 <20120410142213.GA13294@srcf.ucam.org>
 <4F846D53.10409@meetinghouse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F846D53.10409@meetinghouse.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 01:26:43PM -0400, Miles Fidelman wrote:
> For what it's worth, creating a path for X86_64 mode to reboot
> through the bios seems like
> a good thing to put on the wish list.

Not really - it's far more attractive to figure out how our behaviour is 
differing from Windows and change it to match. I'll see what I can find 
out about this machine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
