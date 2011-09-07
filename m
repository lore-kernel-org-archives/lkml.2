Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1IGRoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:44:38 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58482 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755896Ab1IGRog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:44:36 -0400
Date: Wed, 7 Sep 2011 10:44:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        linux-kernel@vger.kernel.org, Jon Mason <mason@myri.com>,
        Jordan_Hargrave@dell.com
Subject: Re: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max Payload
 Size on fabric"
Message-ID: <20110907104432.2f9d8b0a@jbarnes-x220>
In-Reply-To: <CA+5PVA5aEAgdKexWK_cg2zRJk5CFsg6rhp9Wx+80GjR7iaLkOA@mail.gmail.com>
References: <20110906173605.GA12577@hostway.ca>
	<87aaag9vb8.fsf@begreifnix.stackframe.org>
	<CA+5PVA5aEAgdKexWK_cg2zRJk5CFsg6rhp9Wx+80GjR7iaLkOA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 50.0.61.98 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011 12:52:25 -0400
Josh Boyer <jwboyer@gmail.com> wrote:

> On Wed, Sep 7, 2011 at 12:22 PM, Sven Schnelle <svens@stackframe.org>
> wrote:
> > Simon Kirby <sim@hostway.ca> writes:
> >
> >> Hello!
> >>
> >> Since trying 3.1-rc4 on a few Dell servers, all of them have
> >> booted up with the amber error LED lit. "ipmitool sel list" shows:
> >>
> >>    1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 | Log
> >> area reset/cleared | Asserted 2 | 09/06/2011 | 17:25:38 | Critical
> >> Interrupt #0x18 | Bus Fatal Error | Asserted 3 | 09/06/2011 |
> >> 17:25:38 | Unknown #0x1a | 4 | 09/06/2011 | 17:25:38 | Unknown
> >> #0x1a |
> >
> > I'm seeing exact the same issue on a Dell 1950 Server. If anyone
> > wants me to try additional debugging/patches, feel free to do
> > so. Unfortunately i don't have the time/knowledge to debug that by
> > myself.
> 
> I thought Jesse or Jon had a revert or partial fix queued up to send
> to Linus, but I don't see anything in or post -rc5 yet.  That was
> indicated in https://bugzilla.kernel.org/show_bug.cgi?id=42162
> 
> Jesse, Jon?

kernel.org is still down and I haven't pushed anything to github.  I
asked Jon to send his patch directly to Linus today instead.

Thanks,
Jesse
