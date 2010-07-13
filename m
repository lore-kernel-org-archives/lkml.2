Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0GMBSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:18:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0GMBSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J8xgBG4519XtGnDdQGvb4FdfsVyqLM8wMpWIZE7Y3q5RGmDowJv+nryHFVc3DNkHS7
         pWmfrLWzkQFul+E+dlMAfduPfDg3VxoincxdjqMkXvPc6Ppm+nZv5YECMqRSYDRmwu21
         eE/XaOyUmbXI6r8fqqtOo2VDdvOsMS48lXSng=
MIME-Version: 1.0
In-Reply-To: <20100708210244.GA2266@kroah.com>
References: <1278207986-14309-1-git-send-email-ehames@gmail.com>
	<20100708210244.GA2266@kroah.com>
Date: Mon, 12 Jul 2010 22:18:33 -0300
Message-ID: <AANLkTin5QKRuKqklEgnn_UkW6AUbV_5clpFQLeioGdnC@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: wlan-ng: fix checkpatch warnings in 
	hfa384x.h
From: Edgardo Hames <ehames@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 6:02 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, Jul 03, 2010 at 10:46:25PM -0300, Edgardo Hames wrote:
>> Fixed spaces before tabs, removed unused variables and all typedefs.
>>
>> Signed-off-by: Edgardo Hames <ehames@gmail.com>
>
> This doesn't apply against the latest linux-next tree, care to respin it
> and resend both of these?

Shall I use linux-next/stable to respin the patch? I tried building
linux-next/master and the module doesn't even build.

Thanks,
Edgardo
-- 
The mere formulation of a problem is far more essential than its solution,
which may be merely a matter of mathematical or experimental skills.
-- Albert Einstein
