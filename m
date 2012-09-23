Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2IWPln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 11:41:43 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44915 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab2IWPll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 11:41:41 -0400
From: Nix <nix@esperi.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to lose this disk controller?
References: <87mx0lsv4d.fsf@spindle.srvr.nix>
	<FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com>
Emacs: anything free is worth what you paid for it.
Date: Sun, 23 Sep 2012 16:41:29 +0100
In-Reply-To: <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> (Chris
	Murphy's message of "Wed, 19 Sep 2012 14:19:29 -0600")
Message-ID: <87r4pslpau.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-INFN-TO-Metrics: spindle 1233; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2012, Chris Murphy outgrape:

>
> On Sep 19, 2012, at 12:52 PM, Nix wrote:
>
>> So I have this x86-64 server running Linux 3.5.1 with a SATA-on-PCIe
>> Areca 1210 hardware RAID-5 controller 
>
> Did you find this? Same controller family. Weird that this just shows
> up now, but perhaps instead of it being "bad hardware" out the gate,
> something's happened to it and now it's failing as you suspect.

Hm, it's possible I suppose. Just as possible that a disk is dying.


It looks to have been a one-off transient -- no recurrence yet, touch
wood :)

-- 
NULL && (void)
