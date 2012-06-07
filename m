Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2FGUbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:31:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52472 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2FGUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:30:59 -0400
MIME-Version: 1.0
In-Reply-To: <x4962b2aoic.fsf@segfault.boston.devel.redhat.com>
References: <CA+Z7AcYDcZiAxPr+Au8PKoNzoT6G_0F0dAn75nb9ktXp9kBf9g@mail.gmail.com>
	<x497gvjb3dn.fsf@segfault.boston.devel.redhat.com>
	<CA+Z7AcZ=Qf7d6iCziTsi=AH+CjWkhkWeGzhOAY0VqVX3Ni_fXw@mail.gmail.com>
	<x4962b2aoic.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 7 Jun 2012 23:30:55 +0300
Message-ID: <CA+Z7AcZnAOhrqLnYrAubAb9U1HPXgPS2TwLpN4_N-iDnG+2dyA@mail.gmail.com>
Subject: Re: [PATCH] change lock model in aio_put_req
From: mihailov ivan <mihailov.iaa@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> From side - never changed, only we will can execute this call in
>> interrupt context.  I understood what is works as designed but don't
>> understood why we can't imporve this call, it's 'fairly convention in
>> the kernel'?
>
> Changing this is simply not an improvement, it's just a change with no
> benefit.  There's really no point.
>
okay, got it.

> Now, are you going to tell me that you want to call this function from
> interrupt context in some third party driver?  What's the real
> motivation for this patch?
You are right, I'm supporting drivers which are calling this function
from interrupt context.
And I'm trying to find proper way to fix it.
It is clear that this patch is pointless in general case and
I'll try to avoid using this call from interrupt context.
Thanks for your help and patience.
