Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1CaHnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:43:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49047 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1CaHnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:43:23 -0400
Date: Thu, 31 Mar 2011 09:43:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Francis St. Amant" <Francis.St.Amant@riverbed.com>
Cc: Borislav Petkov <bp@amd64.org>, David Miller <davem@davemloft.net>,
        "Luck, Tony" <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Message-ID: <20110331074318.GB27618@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Francis St. Amant" <Francis.St.Amant@riverbed.com>,
	Borislav Petkov <bp@amd64.org>, David Miller <davem@davemloft.net>,
	"Luck, Tony" <tony.luck@intel.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4D8C6C80.8010600@redhat.com>
 <20110325141322.GB28313@gere.osrc.amd.com>
 <4D8D078C.1040201@redhat.com>
 <20110328170302.GF11590@aftab>
 <4D90E525.4030709@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301A7A60074@orsmsx505.amr.corp.intel.com>
 <20110330175106.GB1601@aftab>
 <05E7F0869FB1C54AA467D77BC9C9E63F3FF7EEC271@MAILBOXES.nbttech.com>
 <20110330195025.GA4297@aftab>
 <05E7F0869FB1C54AA467D77BC9C9E63F3FF7EEC289@MAILBOXES.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05E7F0869FB1C54AA467D77BC9C9E63F3FF7EEC289@MAILBOXES.nbttech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 01:00:46PM -0700, Francis St. Amant wrote:
> If it's not easy from your side, I can go to our IT and ask if they
> can revive Arthur's account just to send this one unsubscribe :)

Well, if you have some idle time you could give that a try :).

> FWIW on the below email, I do agree that some way to save OOPS output
> is very useful. In our case Arthur created a special serial driver
> which wrote to EEPROM instead of console--besides not endangering the
> disk, a lot less SW has to be executed to save the data. Then we fetch
> it back on next boot.

Yeah, the problem is, we want to have this working for the majority of
machines out there. I'm assuming there should be some kind of EEPROM
memory available for BIOS to store its config or so which we could
hijack. But I don't know for sure - I'll have to research this a bit.
And besides, interfering with BIOS is almost always bound to fail.
Hmmm...

Thanks.

-- 
Regards/Gruss,
    Boris.
