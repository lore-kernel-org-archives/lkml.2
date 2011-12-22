Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1LVRFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:05:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46155 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1LVRFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:05:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
	<CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
Date: Thu, 22 Dec 2011 18:05:30 +0100
Message-ID: <CAFLxGvxQ0E+j1LHfN3fCMM_TVqV6QG3B=VQiy1FPGdn5senBDw@mail.gmail.com>
Subject: Re: Intercepting system calls
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 5:59 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
> Hello Richard,
> Thank you very much for your reply.
>
> On Thu, Dec 22, 2011 at 10:12 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Thu, Dec 22, 2011 at 5:07 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
>>> Hello all,
>>>
>>> I am writing an application for which I need to intercept some
>>> filesystem system calls eg. unlink. I need unlink to call my code
>>> before deleting abc so that I could probably prevent unlink . I would
>>> like to implement this in a kernel module instead of modifying kernel
>>> code itself. I would like to intercept system calls by replacing
>>> system calls but I have not been able to find any method of doing that
>>> in linux > 3.0. Please suggest some method of doing that.
>>>
>>
>> Intercepting system calls is very bad, don't do it.
> Oh. I will not do it then, could you suggest me something so that I
> could prevent unlink on some file say using kernel support. I want to
> save file on unlink how could I do that without kernel support, or how
> could I do that using a kernel module.
>>

It depends on your application.
Samba has vfs_recycle.
You can also write a fuse-filesystem.
Or use ptrace().

Select your pain. ;)

-- 
Thanks,
//richard
