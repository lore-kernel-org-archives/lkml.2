Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0G1NMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:12:13 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:30469 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0G1NMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:12:09 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: "Frazier, Daniel Kent (ProLiant Linux)" <daniel_frazier@hp.com>,
        Wim Van Sebroeck <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Jul 2010 13:10:02 +0000
Subject: RE: [PATCH 00/15] hpwdt: make NMI code a config option (+ other
 cleanup)
Thread-Topic: [PATCH 00/15] hpwdt: make NMI code a config option (+ other
 cleanup)
Thread-Index: Acst5qKoBDJ9tGTATMW3XPgdUhu3ZAAb3DFg
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC149769B9E0305@GVW1091EXB.americas.hpqcorp.net>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Tom Mingarelli <Thomas.mingarelli@hp.com>

> -----Original Message-----
> From: Frazier, Daniel Kent (ProLiant Linux)
> Sent: Tuesday, July 27, 2010 6:51 PM
> To: Wim Van Sebroeck
> Cc: linux-kernel@vger.kernel.org; Mingarelli, Thomas
> Subject: [PATCH 00/15] hpwdt: make NMI code a config option (+ other
> cleanup)
> 
> hwpdt includes an NMI-decoding feature, but the watchdog interface is
> quite
> usable without it. This patchset makes it possible to build hpwdt without
> the
> NMI functionality, as well as some general cleanup.
> 
>  Kconfig |   22 +++++--
>  hpwdt.c |  181 ++++++++++++++++++++++++++++++++++++----------------------
> ------
>  2 files changed, 119 insertions(+), 84 deletions(-)

