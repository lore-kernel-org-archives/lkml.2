Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0K0S50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 13:57:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44941 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0K0S5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 13:57:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:in-reply-to:references:user-agent:date:message-id
         :mime-version:content-type;
        b=L6oISWnPbEm0sphEX6pAj6qKMcDaAp5s/YD33SJ31q4Q1w4t16H+Jae6LXXnX4YenS
         pGC50zdLv+rom02kRFd3R+LFMJUnqd70wc1YiUuAt1eTUcW7Awy4gBkT+Ia5cKM2ck9m
         eU8Wd+5DnJ049HxhN8565STVQ7bYSD8kgXgQg=
From: Ben Gamari <bgamari@gmail.com>
To: jason.vas.dias@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: per-chroot clock module ?
In-Reply-To: <201011271821.35039.jason.vas.dias@gmail.com>
References: <201011271821.35039.jason.vas.dias@gmail.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sat, 27 Nov 2010 13:57:19 -0500
Message-ID: <874ob2r3w0.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010 18:21:34 +0000, Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
> Greetings -
> 
> Sorry in advance if this is a stupid idea, but -
> 
> I'd really like to be able to set a distinct "clock" for a specific chroot environment, 
> such that the super-user could call :
> [snip]

It certainly doesn't sound like a particularly good idea to me. This
would add great complexity to the kernel while having very few
users. Perhaps there's something I haven't considered but I can't think
of any good applications for this sort of functionality. Do you have
something in particular in mind?

It seems like what you want here is simple virtualization. Have you
considered KVM? The closest thing to your request currently upstream is
containers, although I'm unsure of whether a container can be created
with an independent clock. Might be something to look into.

Cheers,

- Ben
