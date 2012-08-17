Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2HQKbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:31:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43841 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab2HQKa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:30:58 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Joel Becker'" <jlbec@evilplan.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
 <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
 <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
 <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
 <502CF9E3.2010608@linutronix.de>
 <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
 <502E0D3B.10006@linutronix.de>
In-reply-to: <502E0D3B.10006@linutronix.de>
Subject: RE: [RFC 0/2] USB gadget - configfs
Date: Fri, 17 Aug 2012 12:30:49 +0200
Message-id: <000201cd7c63$60186370$20492a50$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac18Wc75bQqaZfcMTU+uau71hvtmOQABtUBQ
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sebastian, Hello Joel,

On Friday, August 17, 2012 11:22 AM Sebastian Andrzej Siewior wrote:

<snip>

> There is a separation between "setting myself up" and "seeing that a host
> wants to talk to me". You are a woman. And if you not done yet done you
ignore
> the host until you are ready. Can also be ready before the host wants to
talk
> to you. It depends on your mood / use case (give the use the choice
between
> storage & network and offer always both because we are self powered).
> 

You never know when she is ready... ;)

Please note, that in the example implementation it is userspace
who needs to explicitly store "1" into the "connect" attribute;
if it is not set, connecting the cable will have no effect and,
conversely, if the cable is connected but the "1" is not stored,
the gadget will not be seen by the host.

Andrzej


