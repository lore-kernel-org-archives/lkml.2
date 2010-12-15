Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0LOK4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:56:39 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:61322 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814Ab0LOK4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:56:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYFAOorCE3CTtAn/2dsb2JhbACVeI4tc8FQhUoEins
Date: Wed, 15 Dec 2010 11:56:26 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: timer Q : request callback 2 ms after interrupt to drop RTS on
	RS485
Message-ID: <20101215105626.GA3083@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux timer experts

I need to arm a timer to expire about 1.5 ms after an interrupt.

How can I do that ?

Thanks in advance

Philippe

More context for the interested ones : I need to deactivate the RTS signal
on a serial line, but I get only TxREADY interrupts, not TxEMPTY ones.
Knowing the hardware and baud rate involved I know how much time is needed
to flush the last bytes and bits and I need to drop RTS as soon as the
last bit is sent.
Of course, in the timer callback I'll do a small amount of busy waiting
to be sure TxEMPTY state is reached.

-- 
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
