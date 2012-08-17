Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab2HQKeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:34:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:49179 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab2HQKeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:34:14 -0400
Message-ID: <502E1E23.60201@linutronix.de>
Date: Fri, 17 Aug 2012 12:34:11 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: "'Joel Becker'" <jlbec@evilplan.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com> <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com> <000501cd5e79$a770be50$f6523af0$%p@samsung.com> <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com> <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com> <502CF9E3.2010608@linutronix.de> <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com> <502E0D3B.10006@linutronix.de> <000201cd7c63$60186370$20492a50$%p@samsung.com>
In-Reply-To: <000201cd7c63$60186370$20492a50$%p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:30 PM, Andrzej Pietrasiewicz wrote:
>> There is a separation between "setting myself up" and "seeing that a host
>> wants to talk to me". You are a woman. And if you not done yet done you
> ignore
>> the host until you are ready. Can also be ready before the host wants to
> talk
>> to you. It depends on your mood / use case (give the use the choice
> between
>> storage&  network and offer always both because we are self powered).
>>
>
> You never know when she is ready... ;)
>
> Please note, that in the example implementation it is userspace
> who needs to explicitly store "1" into the "connect" attribute;
> if it is not set, connecting the cable will have no effect and,
> conversely, if the cable is connected but the "1" is not stored,
> the gadget will not be seen by the host.

maybe we should rename "connect" here to "ready" or "available". It
seems to cause confusion.

>
> Andrzej

Sebastian
