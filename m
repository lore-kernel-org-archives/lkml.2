Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045Ab0EEIud convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Wed, 5 May 2010 04:50:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38026 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775Ab0EEIua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:50:30 -0400
Date: Wed, 05 May 2010 10:50:45 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 0/7] The FunctionFS composite function
In-reply-to: <20100504173249.GA20588@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <op.vb75ivuf7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1271406290.git.mina86@mina86.com>
 <20100504173249.GA20588@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 16, 2010 at 11:49:25AM +0200, Michal Nazarewicz wrote:
>> This is the second version of the FunctionFS patchset.

On Tue, 04 May 2010 19:32:49 +0200, Greg KH <greg@kroah.com> wrote:
> Yet your Subject says "v3" :)

Yes, sorry.  I forgot to modify the cover letter.

> Are you resending these again?

Yes.  I wanted to send them yesterday but some we detected some issues =
with
setup requests.  It seems it's not the problem with FunctionFS but othe=
r
ports of our platform but still I first want to sort that out.  I shoul=
d send
patches by the end of the week.

--=20
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=3D./ `o
| Computer Science,  Micha=C5=82 "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
