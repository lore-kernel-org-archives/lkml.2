Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0JJOAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:00:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54754 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0JJOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:00:31 -0400
Message-ID: <4CB1C68F.1080905@mvista.com>
Date: Sun, 10 Oct 2010 17:58:39 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Add Opticon OPN2001 write support
References: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org> <1286692340-18639-3-git-send-email-alon-git@nolaviz.org> <4CB19B1F.9000300@ru.mvista.com> <20101010123453.GA21060@kroah.com>
In-Reply-To: <20101010123453.GA21060@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/10/10 16:34, Greg KH wrote:

>>> OPN2001 expects write operations to arrive as a vendor-specific command
>>> through the control pipe (instead of using a separate bulk-out pipe).

>>> Signed-off-by: Alon Ziv<alon-git@nolaviz.org>
>>> ---
>>>    drivers/usb/serial/opticon.c |   30 ++++++++++++++++++++++++++----
>>>    1 files changed, 26 insertions(+), 4 deletions(-)

>>> diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
>>> index 9ff19c8..4fe7c3d 100644
>>> --- a/drivers/usb/serial/opticon.c
>>> +++ b/drivers/usb/serial/opticon.c
>> [...]

>>> +	} else {
>>> +		struct usb_ctrlrequest *dr;
>>> +
>>> +		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);

>>     sizeof(*dr) is a preferred form.

> No, people disagree on this, there is no 'preferred' form, you are free
> to use either way.

    Please refer to the CodingStyle chapter 14. This is preferred form, 
according to it...

WBR, Sergei

