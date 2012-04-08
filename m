Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2DHW1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:27:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60737 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab2DHW1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:27:18 -0400
Message-ID: <4F8210A5.7000900@zytor.com>
Date: Sun, 08 Apr 2012 15:26:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <4F80892A.7050104@zytor.com> <4F81D5C4.9000503@openvz.org> <20120408231841.42e28867@pyramind.ukuu.org.uk>
In-Reply-To: <20120408231841.42e28867@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 03:18 PM, Alan Cox wrote:
> 
> Ok I'm putting my tty maintainers hat on at this point because nobody
> seems to be listening
> 
> I'm NAKking this change, I'm NAKking the feature-removal change.
> 
> If you want this to change convince the distributions there is a point in
> supporting it. This is the *wrong* forum to force a cornercase feature
> onto a bazillion users, and the wrong way to strongarm maintainers of the
> relevant user space.
> 
> If udev has a problem handling it nicely because of the way the link is
> generated then *fix that problem* so udev automatically gets both cases
> right. If need be we can add more messages to udev to tell it what is
> expected and what devtmpfs should produce.
> 

What if it turns out we can make udev/devtmpfs make this happen
transparently (which it sounds like it might be possible)?  Would you be
okay with removing the "implicit bind mount" property of the current
devpts then?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

