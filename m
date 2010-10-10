Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0JJOwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:52:13 -0400
Received: from kroah.org ([198.145.64.141]:41123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0JJOwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:52:12 -0400
Date: Sun, 10 Oct 2010 07:52:54 -0700
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Add Opticon OPN2001 write support
Message-ID: <20101010145254.GA463@kroah.com>
References: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org> <1286692340-18639-3-git-send-email-alon-git@nolaviz.org> <4CB19B1F.9000300@ru.mvista.com> <20101010123453.GA21060@kroah.com> <4CB1C68F.1080905@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1C68F.1080905@mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 05:58:39PM +0400, Sergei Shtylyov wrote:
> Hello.
>
> On 10/10/10 16:34, Greg KH wrote:
>
>>>> OPN2001 expects write operations to arrive as a vendor-specific command
>>>> through the control pipe (instead of using a separate bulk-out pipe).
>
>>>> Signed-off-by: Alon Ziv<alon-git@nolaviz.org>
>>>> ---
>>>>    drivers/usb/serial/opticon.c |   30 ++++++++++++++++++++++++++----
>>>>    1 files changed, 26 insertions(+), 4 deletions(-)
>
>>>> diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
>>>> index 9ff19c8..4fe7c3d 100644
>>>> --- a/drivers/usb/serial/opticon.c
>>>> +++ b/drivers/usb/serial/opticon.c
>>> [...]
>
>>>> +	} else {
>>>> +		struct usb_ctrlrequest *dr;
>>>> +
>>>> +		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
>
>>>     sizeof(*dr) is a preferred form.
>
>> No, people disagree on this, there is no 'preferred' form, you are free
>> to use either way.
>
>    Please refer to the CodingStyle chapter 14. This is preferred form, 
> according to it...

Hm, I didn't realize it had been written down.

Anyway, again, no big deal, it's up to the author/maintainer which way
they prefer, and for me, I can handle it either way.

thanks,

greg k-h
