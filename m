Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0JGEL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:11:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58032 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0JGEL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GzrTz9JfUDCigb9EJsLyPgA+OIHY6cmelQr4gRm7Llai033J5JHzL4Bn6TGAeMNUKX
         DUpg1MYdlNTFGooz1gt15DpBsWj9lTaCqZ+urMhYexDQPb6ih7NV87hCb1/G7nyb6WjH
         hfiCdSPQz/h27MvWcUxM2bf2C4gGDqD8D8gNk=
MIME-Version: 1.0
In-Reply-To: <20101006202313.GG26397@kroah.com>
References: <1286032307-3350-1-git-send-email-rahul.ruikar@gmail.com>
 <AANLkTin57LWwuxjXB3ORt4+hzHeDBatWP2K+H7JDsTkm@mail.gmail.com> <20101006202313.GG26397@kroah.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Thu, 7 Oct 2010 09:41:34 +0530
Message-ID: <AANLkTi=L+DqsQBEDcaCmmwRKKk=-XkTNM4PaLvpYdgxZ@mail.gmail.com>
Subject: Re: [RESEND/PATCH] usb: gadget: dummy_hcd: Fix error path
To: Greg KH <greg@kroah.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sent in another mail.

- Rahul Ruikar





On 7 October 2010 01:53, Greg KH <greg@kroah.com> wrote:
> On Sat, Oct 02, 2010 at 08:43:44PM +0530, Rahul Ruikar wrote:
>> updated patch attached here.
>
> It's attached in base64 mode, sorry, I can't apply it.  Please resend it
> properly.
>
> greg k-h
>
