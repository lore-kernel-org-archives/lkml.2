Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0KWS0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:26:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53644 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0KWS0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:26:49 -0500
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not
 accessable
From: Peter Zijlstra <peterz@infradead.org>
To: sedat.dilek@gmail.com
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimsz2XWQq7bJ4uhWXhoPuQw-fSJbCJ6D6Xo69XM@mail.gmail.com>
References: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
	 <20101123165657.GF18100@redhat.com>
	 <AANLkTimsz2XWQq7bJ4uhWXhoPuQw-fSJbCJ6D6Xo69XM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 19:27:07 +0100
Message-ID: <1290536827.2072.417.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 19:21 +0100, Sedat Dilek wrote:
> Due to BIOS l(ocal)apic is not possible:
> 
> # dmesg | grep -i apic
> [    0.000000] Using APIC driver default
> [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
> [    0.000000] APIC: disable apic facility
> [    0.000000] APIC: switched to apic NOOP
> [    0.008891] no APIC, boot with the "lapic" boot parameter to force-enable it.
> [    0.036141] Local APIC not detected. Using dummy APIC emulation. 

Have you tried booting with "lapic" as the second last msg suggests you
do?
