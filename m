Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2KPRHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:07:50 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49566 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2KPRHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:07:48 -0500
MIME-Version: 1.0
In-Reply-To: <20121116170537.GA30626@kroah.com>
References: <1353084759-8792-1-git-send-email-johanmeiring@gmail.com>
	<20121116170537.GA30626@kroah.com>
Date: Fri, 16 Nov 2012 19:07:48 +0200
Message-ID: <CALqZ13tK9Dgt3sBYUAbEmNKenOguHsXV9HNZABz7S=vMP6poUQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging: wlags49_h2: ap_h2: fixes coding style issues
From: Johan Meiring <johanmeiring@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pe1dnn@amsat.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for the feedback.  Lesson learned, will remember to do things
in smaller increments and also wrap lines better.

Kindly disregard all three patches.

I'll redo and resend soon :)

Johan

On 16 November 2012 19:05, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 16, 2012 at 06:52:39PM +0200, Johan Meiring wrote:
>> This corrects several instances of spaces before tabs and incorrect spacing around "*" characters.  It also fixes some 80+ character line length issues, but the majority of such cases have been left as is, as this was probably the author's intention.
>
> Please wrap your changelog lines at the properly length (i.e. 72
> columns)
>
> Also, please only do one thing per patch.  You are doing multiple things
> here, which makes it hard to review.
>
> Same goes for the other patches in this series, please break it up into
> smaller steps, which makes for more patches, but it makes it easier to
> review to ensure you didn't do something wrong.
>
> Care to redo this and resend it?
>
> thanks,
>
> greg k-h
