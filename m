Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1LWCXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:23:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59097 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1LWCXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:23:30 -0500
MIME-Version: 1.0
In-Reply-To: <20211.28256.111279.27933@quad.stoffel.home>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
 <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com> <20211.28256.111279.27933@quad.stoffel.home>
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Fri, 23 Dec 2011 07:52:59 +0530
Message-ID: <CAOh0hwPeveaEaNv_mjNVLM36JSbObX4n5y1jC_Yp5MwdBA0Sxw@mail.gmail.com>
Subject: Re: Intercepting system calls
To: John Stoffel <john@stoffel.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

On Thu, Dec 22, 2011 at 11:22 PM, John Stoffel <john@stoffel.org> wrote:
>>>>>> "Gaurav" == Gaurav Saxena <grvsaxena419@gmail.com> writes:
>
>>> Intercepting system calls is very bad, don't do it.
>
> Gaurav> Oh. I will not do it then, could you suggest me something so
> Gaurav> that I could prevent unlink on some file say using kernel
> Gaurav> support. I want to save file on unlink how could I do that
> Gaurav> without kernel support, or how could I do that using a kernel
> Gaurav> module.
>
> Write a FUSE module to mount the filesystem through, inside your FUSE
> module you can intercept the unlink/truncate/write calls and decide
> what you want to have happen.
>
> John
I would like to write it differently for each type of filesystem ?
Because what operations to call after my function depends on this.
Also Can I mount "/" in this way ?


-- 
Thanks and Regards ,
Gaurav
