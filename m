Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919Ab2CAFBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 00:01:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54092 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2CAFBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 00:01:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of justinmattock@gmail.com designates 10.204.156.204 as permitted sender) smtp.mail=justinmattock@gmail.com; dkim=pass header.i=justinmattock@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120229235619.GA26970@kroah.com>
References: <1330356363-3208-1-git-send-email-justinmattock@gmail.com>
	<20120229235619.GA26970@kroah.com>
Date: Wed, 29 Feb 2012 21:01:42 -0800
Message-ID: <CAKFRV=P3_wUJfMvE4JneAMiMUQNDOP+_2y+GbLqa2=3x1anYYA@mail.gmail.com>
Subject: Re: [PATCH]drivers:staging:iio Fix typos and comments in staging iio.
From: Justin Mattock <justinmattock@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: trivial@vger.kernel, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, jic23@cam.ac.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 3:56 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Feb 27, 2012 at 07:26:03AM -0800, Justin P. Mattock wrote:
>> From: "Justin P. Mattock" <justinmattock@gmail.com>
>>
>> The below patch fixes some comments and some typos that I have found
>> while reading drivers/staging/iio/*
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> This patch doesn't apply to my tree, care to redo it against the next
> linux-next release and resend it?
>
> thanks,
>
> greg k-h

yeah kind of bad to have a typo fix with a typo on the --to.. anyway
let me pull the latest linux-next and resend a clean one..

-- 
Justin P. Mattock
