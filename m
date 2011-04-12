Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1DLHHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:07:54 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:59081 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab1DLHHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:07:53 -0400
Message-ID: <4DA3FA7E.2080800@ladisch.de>
Date: Tue, 12 Apr 2011 09:08:46 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Harald Welte <laforge@gnumonks.org>
CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-kernel@vger.kernel.org,
        Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC] NFC subsystem prototype
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com> <20110409130945.GC3248@prithivi.gnumonks.org> <BANLkTinTXNby_zc7yz29hAdRmNK3rRht9A@mail.gmail.com> <20110412060813.GS9690@prithivi.gnumonks.org>
In-Reply-To: <20110412060813.GS9690@prithivi.gnumonks.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Welte wrote:
> Also, I'm not quite clear what's the situation with regard to the NFC trademark,

As far as I can tell, "NFC" itself isn't trademarked; it's used in the
ISO standard, and the Wikipedia page mentions several organizations like
NFC World, NFC Times, NFC Lab, and www.libnfc.org.  (What _is_
trademarked is the "N-Mark": <http://www.nfc-forum.org/resources/N-Mark>.)

> i.e. if it wise to use the trademark.  There has been one previous case with
> the 'firewire' situation, where firewire is the trademark and IEEE 1394 the name
> of the technical specification - and the the Linux subsystem is alled
> 'ieee1394'...

In recent kernels, the "ieee1394" subsystem has been replaced by the new
subsystem named "firewire" (and called "Juju").


Regards,
Clemens
