Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2DHWqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:46:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60841 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab2DHWqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:46:12 -0400
Message-ID: <4F821524.9090702@zytor.com>
Date: Sun, 08 Apr 2012 15:45:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <4F80892A.7050104@zytor.com> <4F81D5C4.9000503@openvz.org> <20120408231841.42e28867@pyramind.ukuu.org.uk> <4F8210A5.7000900@zytor.com> <20120408234641.788f8426@pyramind.ukuu.org.uk>
In-Reply-To: <20120408234641.788f8426@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 03:46 PM, Alan Cox wrote:
>> What if it turns out we can make udev/devtmpfs make this happen
>> transparently (which it sounds like it might be possible)?  Would you be
>> okay with removing the "implicit bind mount" property of the current
>> devpts then?
> 
> Once we get to the point where it "just works" I'm quite happy for that
> to happen unless it turns out there's any large code size/performance
> hits in having the feature always on. I don't see any.
> 

No, it's actually the other way around... it lets us take some pretty
nice shortcuts.

	-hpa


