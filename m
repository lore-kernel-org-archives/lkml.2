Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1GESCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:02:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54067 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1GESCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:02:44 -0400
Date: Tue, 5 Jul 2011 19:02:27 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        rtc-linux@googlegroups.com, dannf@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable rtc-efi
Message-ID: <20110705180227.GD30531@srcf.ucam.org>
References: <4E12DBAB020000780004C1B2@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E12DBAB020000780004C1B2@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 08:38:51AM +0100, Jan Beulich wrote:
> Besides a Kconfig change this just requires creating a respective
> platform device.

"During runtime, if a PC-AT CMOS device is present in the platform the 
caller must synchronize access to the device before calling GetTime()."

This shouldn't be enabled on PC hardware without locking to avoid races 
with direct ahrdware access.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
