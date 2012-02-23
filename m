Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2BWGcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 01:32:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54272 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2BWGcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 01:32:18 -0500
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com> <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com> <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com> <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com> <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net> <1329890251.2193.50.camel@perseus.themaw.net> <1329903139.2193.66.camel@perseus.themaw.net> <CA+55aFwkYkSC1O=fWtj1CBAeKDP-ogEL4Mai8U-dd2uCMArppw@mail.gmail.com> <1329961703.2244.8.camel@perseus.themaw.net> <1329962085.2244.10.camel@perseus.themaw.net> <1329963683.2244.19.camel@perseus.themaw.net> <1329978558.25314.0.camel@perseus.themaw.net>
User-Agent: K-9 Mail for Android
In-Reply-To: <1329978558.25314.0.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: compat: autofs v5 packet size ambiguity - update
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 22 Feb 2012 22:31:38 -0800
To: Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <2b90acba-a8e9-485a-b2a6-608d61751f2c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

However, I liked Linus' approach.of using the version ioctl; any reason not to?

Ian Kent <raven@themaw.net> wrote:

>On Thu, 2012-02-23 at 10:21 +0800, Ian Kent wrote:
>> On Thu, 2012-02-23 at 09:54 +0800, Ian Kent wrote:
>> > On Thu, 2012-02-23 at 09:48 +0800, Ian Kent wrote:
>> > > On Wed, 2012-02-22 at 08:12 -0800, Linus Torvalds wrote:
>> > > > On Wed, Feb 22, 2012 at 1:32 AM, Ian Kent <raven@themaw.net>
>wrote:
>> > > > >
>> > > > > Oh, DOH ...
>> > > > >
>> > > > > The process mounting the autofs mount is passing the pipe it
>will use
>> > > > > for communication via a mount option so we can do this right
>in
>> > > > > fill_super.
>> > > > 
>> > > > No, we really cannot.
>> > > 
>> > > Sorry, I think your wrong this time.
>> > 
>> > On second thought, I suppose other user space users don't "have" to
>use
>> > mount(2) ....
>> 
>> Thomas, what does systemd use to mount the autofs mounts that it
>uses?
>
>Mmm ... AFAICS systemd uses mount(2) so that looks OK too.
>
>Ian

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
