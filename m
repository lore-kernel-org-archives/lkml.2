Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935326Ab1ETFZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:25:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab1ETFZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jPRkWfBp18YFiXFgFE9Qjb+XSM3QWPxaZIaVr4NFkfxym+NQ34YhM+eYwgc7CxkCxs
         nx2IxzrLXTKu1yvmqpZg36QYpbH4SLuFsevlp/aIN/DZhALGk7qULTbHqzaJ8N033dq6
         Sg3/ZJYioTJLUdA6A3kPPdk7VkEmaHdM2MdlA=
MIME-Version: 1.0
In-Reply-To: <20110520050101.GA7461@kroah.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
	<2ecbb21cffe73acfe291c3c8e5626427ed5c5b43.1305866084.git.mfm@muteddisk.com>
	<20110520050101.GA7461@kroah.com>
Date: Thu, 19 May 2011 22:25:25 -0700
Message-ID: <BANLkTi=N9tAA_gZXgwDDTijyUuLysnQQEQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] staging: usbip: replace usbip_u{dbg,err,info} and
 printk with dev_ and pr_
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: matt mooney <mfm@muteddisk.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:01 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, May 19, 2011 at 09:36:55PM -0700, matt mooney wrote:
>> This switches all of the usbip_u{dbg,err,info} and printk statements to
>> dev_<level>, if possible, or pr_<level> macros. And removes a few
>> unnecessary debug statements.
>>
>> Signed-off-by: matt mooney <mfm@muteddisk.com>
>
> I've already applied this one, right?

I don't think so. I never received a notification from your email bot ;)

-- 
GPG-Key: 9AFE00EA
