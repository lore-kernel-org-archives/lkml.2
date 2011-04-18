Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1DRN6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:58:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36591 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1DRN6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=wrtwcMFzq3MgnLzpGqfPJLl51Z7y6H2mf0RxjfD8oMhRb/Xxi8J5h0QLKYgX5V3qLl
         1j/MKhsy1kga12SXIAgMCpbmYd/liApLsW8dtgM9XR8tm6mxF1iBweWGEXdKQOMlMtFI
         oMFAZmpLYHi6bx7JjkEV5B5wD9ScQLXD43IBA=
MIME-Version: 1.0
In-Reply-To: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 18 Apr 2011 09:57:52 -0400
Message-ID: <BANLkTi=yaXOWnUi2s1A-BtoAFgjExX8q4w@mail.gmail.com>
Subject: Re: [PATCH 0/1] Implement /dev/byte (a generic byte source similiar
 to /dev/zero)
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 07:37, Alexander Holler wrote:
> I don't know if this patch qualifies for inclusion into the mainline kernel, but
> maybe someone else would be interested in such, so I'm posting it here.
>
> The main idea for that device was to have a source for 0xff to clear FLASH based
> devices. And to make it more generic, I've added the possibility to change the
> default value on a per file descriptor basis.
>
> I don't want to discuss if such a device makes sense or if such should be done
> in userspace only. I like it as a device, otherwise I wouldn't have written it.
> So besides this message, I will not take part in such a discussion.

cant you do this with cuse ?  that would satisfy the "has to be a
device" requirement while keeping it in userspace.

although, i have a hard time seeing there be a realistic perf diff with:
tr '\000' '\377' < /dev/zero | dd ......
-mike
