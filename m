Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1LVQmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:42:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42179 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab1LVQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:42:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
Date: Thu, 22 Dec 2011 17:42:40 +0100
Message-ID: <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
Subject: Re: Intercepting system calls
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 5:07 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
> Hello all,
>
> I am writing an application for which I need to intercept some
> filesystem system calls eg. unlink. I need unlink to call my code
> before deleting abc so that I could probably prevent unlink . I would
> like to implement this in a kernel module instead of modifying kernel
> code itself. I would like to intercept system calls by replacing
> system calls but I have not been able to find any method of doing that
> in linux > 3.0. Please suggest some method of doing that.
>

Intercepting system calls is very bad, don't do it.

-- 
Thanks,
//richard
