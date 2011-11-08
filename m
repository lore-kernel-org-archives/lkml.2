Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1KHHsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:48:03 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44650 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751174Ab1KHHr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:47:59 -0500
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX1+5ddx1MKS5TQ6SFsQBgO+X9r9hay5KHanWNJdn8M
	HFtODrF7yKURj9
Message-ID: <4EB8DEAC.7000906@gmx.net>
Date: Tue, 08 Nov 2011 08:47:56 +0100
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com> <4EB7D2D8.2060505@gmx.net> <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
In-Reply-To: <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.2011 13:50, Andrea Gelmini wrote:
> 2011/11/7 Arne Jansen <sensille@gmx.net>:
>> is it 32 or 64 bit?
> 
> 64bit.
> Please take a look at my other reply.

Can you please have a look with strace to make sure it's
really the ioctl the ENOMEM originates froM?

Thanks,
Arne

> 
> Thanks a lot for your time,
> Andrea

