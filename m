Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1LVQ7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:59:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56071 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab1LVQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:59:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Thu, 22 Dec 2011 22:29:22 +0530
Message-ID: <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
Subject: Re: Intercepting system calls
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,
Thank you very much for your reply.

On Thu, Dec 22, 2011 at 10:12 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Dec 22, 2011 at 5:07 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
>> Hello all,
>>
>> I am writing an application for which I need to intercept some
>> filesystem system calls eg. unlink. I need unlink to call my code
>> before deleting abc so that I could probably prevent unlink . I would
>> like to implement this in a kernel module instead of modifying kernel
>> code itself. I would like to intercept system calls by replacing
>> system calls but I have not been able to find any method of doing that
>> in linux > 3.0. Please suggest some method of doing that.
>>
>
> Intercepting system calls is very bad, don't do it.
Oh. I will not do it then, could you suggest me something so that I
could prevent unlink on some file say using kernel support. I want to
save file on unlink how could I do that without kernel support, or how
could I do that using a kernel module.
>
> --
> Thanks,
> //richard



-- 
Thanks and Regards ,
Gaurav
