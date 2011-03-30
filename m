Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1C3KDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:03:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37068 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab1C3KDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=nce+uno7xL+XrrPZC8jsiGsCfSCHqg6NISXi8tAcxIoEF0NYRz18gDtQniRSxR4tX5
         lYIYQypbTSNsr6QC65VshHJ209GV3ji3mIpibWTmUoy96kb0SJKQUAXyYQIq7Vb4oFfV
         zc30cafe1aP+5bzp2f6Ky+oK5eTTdkIjkCzlA=
MIME-Version: 1.0
In-Reply-To: <AANLkTim8S_hjGj3m7FF+1gKOk0Rp1g350NdA1L8kiqzg@mail.gmail.com>
References: <1301465343-6861-1-git-send-email-vapier@gentoo.org> <AANLkTim8S_hjGj3m7FF+1gKOk0Rp1g350NdA1L8kiqzg@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 30 Mar 2011 06:03:11 -0400
X-Google-Sender-Auth: CVL8ZC3N0TAA9DD2HxEnAF7fTMI
Message-ID: <AANLkTin6cZQhnkPgsA8Um9vMxjNoAGmu8mtgEP9Eb8Ni@mail.gmail.com>
Subject: Re: [PATCH] proc: constify status array
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 05:56, Alexey Dobriyan wrote:
> On Wed, Mar 30, 2011 at 9:09 AM, Mike Frysinger wrote:
>> -static const char *task_state_array[] = {
>> +static const char * const task_state_array[] = {
>
> Why this is needed for task_state_array, but not for, say, tgid_base_stuff?

tgid_base_stuff is already declared const.  which your nm output clearly shows.

> This double const is ugly.

quite the opposite.  not declaring const arrays const is ugly.
-mike
