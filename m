Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0FVUNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:13:42 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:43038 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327Ab0FVUNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:13:41 -0400
X-Greylist: delayed 26126 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 16:13:40 EDT
Message-ID: <4C20B364.9060405@blueyonder.co.uk>
Date: Tue, 22 Jun 2010 13:58:12 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: 2.6.35-rc3 E-MU 0404 USB problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an application using the on-board sound card mic which should 
send it's data to the USB card for relay to a Sofweare Defined Radio as 
2 quadrature signals digital (I/Q) for transmission.
On the receiving side it can take data from the Radio at up to 192K 
sample rate --> program --> Speaker on the on-board sound card - that 
works fine.
Transmit fails, dmesg output with 48K sample rate set is:-
[509686.177169] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks sample 
rate attribute bit, cannot set.
[509686.187920] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks sample 
rate attribute bit, cannot set.
[509686.266905] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509686.330901] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509686.353775] ALSA sound/usb/clock.c:214: 6:2:7: endpoint lacks sample 
rate attribute bit, cannot set.
[509686.394898] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509686.458886] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509686.522874] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509823.078594] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks sample 
rate attribute bit, cannot set.
[509823.091571] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks sample 
rate attribute bit, cannot set.
[509823.146811] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509823.202679] ALSA sound/usb/clock.c:214: 6:2:7: endpoint lacks sample 
rate attribute bit, cannot set.
[509823.210807] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509823.274792] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509823.338782] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
[509823.402783] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

