Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab0JFNua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:50:30 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33404 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab0JFNu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XKB3eK4NZT7u6ZsJ1VIyRLehZ8z859CVXlK2K7F/klrG5Z45J8PSB+gOwdNEspi7vi
         q9BZFjolSVNGqaqvkzaCC820b07owBmGIXiBwshoYLhuRnOG5MFlMMDFpOnmFN27VGn+
         AMpq+7yfAg5k2rjsDpEWeF6MD33PEj/8IaaUY=
MIME-Version: 1.0
In-Reply-To: <201010061935.45010.rusty@rustcorp.com.au>
References: <20101005124521.GA2602@darkstar>
	<201010061935.45010.rusty@rustcorp.com.au>
Date: Wed, 6 Oct 2010 21:50:13 +0800
Message-ID: <AANLkTinP7tA87anzgN6Yi3p_FtJ7bJHmEZc6rKX=o+-R@mail.gmail.com>
Subject: Re: [PATCH] kvm: add oom notifier for virtio balloon
From: Dave Young <hidave.darkstar@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 5:05 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 5 Oct 2010 11:15:21 pm Dave Young wrote:
>> Balloon could cause guest memory oom killing and panic.
>>
>> Add oom notify to leak some memory and retry fill balloon after 5 minutes.
>
> Have you tried registering a shrinker?  See mm.h.

Hi, thanks. I didn't know shrinker can shrink mem beyond slab. Will try

>
> Thanks,
> Rusty.
>



-- 
Regards
dave
