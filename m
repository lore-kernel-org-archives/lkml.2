Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2IWOpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 10:45:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41811 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2IWOpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 10:45:20 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20120923064057.GB2994@moon>
References: <20120913095623.GB28508@moon> <20120913135131.5b251797@pyramind.ukuu.org.uk> <20120913125401.GK19956@moon> <20120913172507.5039e3c6@pyramind.ukuu.org.uk> <20120922180639.GC11610@moon> <87txupfr92.fsf@xmission.com> <20120923064057.GB2994@moon>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 23 Sep 2012 07:44:54 -0700
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Message-ID: <0cd1ae78-15ab-4dd4-b98c-e6796b766cfb@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Cyrill Gorcunov <gorcunov@openvz.org> wrote:

>On Sat, Sep 22, 2012 at 06:43:37PM -0700, Eric W. Biederman wrote:
>> 
>> I don't know where this conversation comes from but putting ptys in
>> sysfs in combination with the newinstance mount option is completely
>> broken unless the device name and device number duplication is
>handled,
>> which I don't see here.
>
>Good point, Eric, thanks! I'll take a look on this aspect (I must admit
>I've missed this).

Funny... I gave you that feedback the last go around.
-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
