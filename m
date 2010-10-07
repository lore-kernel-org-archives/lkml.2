Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0JGEJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:09:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34463 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0JGEJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dr7bYpUaFSGCmIH2rZW1W4vSrcv6OVrJ12Yx4wsOwN8yAqoulUeSXa+62mVehIA+01
         Al0EPDNLJ7RcKDhd/2DUKcQxCg2+QvfcAHkxRPXpAvuHvDmx8UvUydDgK2NKS8hOtkrv
         vt9oad6QuIi3jBsWeyk0GyIQOPgjoEmA51iGU=
MIME-Version: 1.0
In-Reply-To: <20101006202143.GE26397@kroah.com>
References: <1286302800-2715-1-git-send-email-rahul.ruikar@gmail.com>
 <4CAB79C4.3030208@ru.mvista.com> <AANLkTinBBUQuEnWzASb5daiE+C3w+Rs8kLdgzK7XAyne@mail.gmail.com>
 <20101006202143.GE26397@kroah.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Thu, 7 Oct 2010 09:25:13 +0530
Message-ID: <AANLkTinGhwDUzuH1O5a31aSpv_mRiyqSi8z1tZm1FERK@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
To: Greg KH <greg@kroah.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just sent in another mail.

- Rahul Ruikar





On 7 October 2010 01:51, Greg KH <greg@kroah.com> wrote:
> On Wed, Oct 06, 2010 at 08:04:23AM +0530, Rahul Ruikar wrote:
>> updated patch with following changes.
>> - variable name changed
>> - comment updated.
>>
>> Please find it attached here.
>
> Please resend it, not attached in base64 format so that I can apply it
> properly.
>
> thanks,
>
> greg k-h
>
