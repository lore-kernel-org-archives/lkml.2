Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab2FWSeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:34:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44548 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2FWSeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:34:12 -0400
MIME-Version: 1.0
In-Reply-To: <1340234315.29885.54.camel@joe2Laptop>
References: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
	<20120620230839.GA17883@kroah.com>
	<1340234315.29885.54.camel@joe2Laptop>
Date: Sun, 24 Jun 2012 00:04:12 +0530
Message-ID: <CAHdPZaMH1vJPsFmGFrrpWNtCxuY+S35-w2j+gbiiE=7jVKLtUQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] staging/rtl8192u: fix coding style problems
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Jun 21, 2012 at 4:48 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-06-20 at 16:08 -0700, Greg Kroah-Hartman wrote:
>> On Wed, Jun 20, 2012 at 12:35:42AM +0530, Devendra Naga wrote:
>> > fixed some of the coding style problems reported by checkpatch
> []
>> > @@ -66,11 +69,10 @@ short eprom_r(struct net_device *dev)
>> >  {
>> >     short bit;
>> >
>> > -   bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
>> > +   bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
>> >     udelay(EPROM_DELAY);
>> >
>> > -   if(bit) return 1;
>> > -   return 0;
>> > +   return !!bit;
>>
>> Oh come on, really?  !! is more "clear" here?
>
> Depends on the reader.  !! is pretty common.
>
>> No, please be painfully obvious, that's the only way to write kernel
>> code.  Not like this.
>
> I'd just make the return a bool instead.
>
 taking another variable and assign it like bool ret = !!bit, and
returning ret?, i think this doesn't look better.
> Also, there are unnecessary parens that could
> be removed to make the code clearer.
>
> (1<<EPROM_R_SHIFT), (1<<EPROM_W_SHIFT) and
> (1<<EPROM_CK_SHIFT) could be new #defines too.
>
>
Will do.

thanks joe.


Devendra.
