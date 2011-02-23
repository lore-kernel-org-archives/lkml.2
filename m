Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1BWTHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:07:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59810 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1BWTHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:07:21 -0500
Message-ID: <4D655A98.3090507@ru.mvista.com>
Date: Wed, 23 Feb 2011 22:06:00 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for .38
References: <20110222232703.GA18987@kroah.com> <4D654626.40901@ru.mvista.com> <20110223180244.GA30106@suse.de>
In-Reply-To: <20110223180244.GA30106@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-02-2011 21:02, Greg KH wrote:

>>> Johan Hovold (2):
>>>        usb: musb: omap2430: fix kernel panic on reboot
>>>        USB: musb: omap2430: fix kernel panic on reboot

>>     It's the same patch repeated twice. I wonder how it was possible
>> without an intevening revert... :-O

> Welcome to git, the amazing tool that can handle duplicate patches on
> different branches, and when merged it knows what to do to resolve the
> issue (i.e. nothing as everything is just fine.)

    I know it can but I just thought it somehow makes them one patch in the 
end. Well, in this case they were not completely identical, so it coulnd't 
have anyway.

> And yes, I know this happened, and I even posted to the linux-usb list
> when it did, so it shouldn't have been a surprise to anyone.

    Sorry, I haven't noticed (or remembered).

> thanks,

> greg k-h

WBR, Sergei
