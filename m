Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0LQJmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 04:42:08 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56638 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0LQJmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 04:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=gsBYrUBTnUbqAArgJxXRXSoJpAP5ZKHQBrsNNMIKjO/3A/2qG/lvzKc7rBFZGbDTiD
         JZRHHKytcD39it4xOiwH6neAhAmE0pyEzQhjUqehjDBelL7fTK6lRgLhuZJmKisWzSMk
         HUQAsGblvoMf2LXq6Z1xAT4uLYTTRDP5z9Hdg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimO=sJ4LnQPeJRwfbCnxn5ANNxtEJw8qNkhjw8V@mail.gmail.com>
References: <AANLkTimO=sJ4LnQPeJRwfbCnxn5ANNxtEJw8qNkhjw8V@mail.gmail.com>
Date: Fri, 17 Dec 2010 15:12:04 +0530
Message-ID: <AANLkTim9uu90Y7hZNJEMtBPiV=DrJfOfyi_FsiNZZ9ZC@mail.gmail.com>
Subject: Re: How to know which interrupt is executing
From: SAURABH MALPANI <saurabh140585@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 2:59 PM, SAURABH MALPANI
<saurabh140585@gmail.com> wrote:
>
> Hello,
> I am not subscribed to this list. So I request to reply to me directly.
> Based on what I looked into the code, the answer is no, but I believe there are many better people who can give an opinion.
> The kernel in_irq() macro returns if the kernel is in interrupt context. But there is no way of knowing which irq the code is running.
> It might seem an odd idea, but I am writing some code which maintains a data structure per irq. Right now I am managing by patching
> manually, but is there any way of getting the value of currently executing interrupt vector. In a generic way? or in a architecture specific way?
>
> --
> Saurabh



--
Saurabh
