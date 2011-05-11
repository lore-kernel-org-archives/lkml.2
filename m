Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab1EKWYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:24:48 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59764 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1EKWYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:24:47 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic Systems TS-5xxx detection
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-reply-to: <20110505143837.7790edd5@lxorguk.ukuu.org.uk>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com> <20110430110705.5ca3376b@lxorguk.ukuu.org.uk> <1304520382-sup-3361@sfl> <20110504162954.7ecf5b5e@lxorguk.ukuu.org.uk> <1304537667-sup-2171@sfl> <20110505143837.7790edd5@lxorguk.ukuu.org.uk>
Date: Wed, 11 May 2011 18:24:44 -0400
Message-Id: <1305150634-sup-4695@v0nbox>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Alan Cox's message of jeu mai 05 09:38:37 -0400 2011:
> > I've looked at that, and the board doesn't support DMI. Elements we have
> > are the processor (i.e. AMD ElanSC520), the BIOS, maybe the memory and
> > PCI bus layouts...
> 
> Well the CPU is a big help that cuts it down a lot. PCI bridge
> subvendor/dev can be a good way to identify boards as well if they
> manufacturers have actually bothered to set them properly.

In a first step, I now check the CPU and the Ethernet chip which are
relevant devices of TS-5xxx boards. The only problem comes from the
TS-5300 board which has a different Ethernet chip, using the ISA bus.
I can't find other relevant device information about this board. So, is
the CPU detection (AMD Elan SC520) enough? Or should I add a module
parameter to specify the board model and avoid this pre-detection?

Thanks,
Vivien.
