Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0HOQRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:17:51 -0400
Received: from borg.asidev.net ([95.141.32.69]:38900 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab0HOQRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:17:50 -0400
Message-ID: <4C67F815.8020808@evidence.eu.com>
Date: Sun, 15 Aug 2010 16:22:13 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Rick Bronson <rick@efn.org>,
        linux-serial@vger.kernel.org
Subject: RS485: ioctls defined twice ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	is there any reason why ioctls TIOCGRS485 and TIOCSRS485 are defined (with the same values) in both include/asm-generic/ioctls.h and arch/arm/include/asm/ioctls.h ?

The same happens also for avr32, powerpc and cris (which, however, defines a different value for TIOCSRS485).

Is it duplicated code ?

Or should these values stay in both asm/ioctls.h and asm-generic/ioctls.h ?

Many thanks,

	Claudio


