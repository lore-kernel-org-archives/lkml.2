Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1FCSjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:39:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49408 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1FCSj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tj8VluNRiIRHknTiqVsE95f+Uf4iNCnS92rtaKSA1lzoyOZGqkmJiyfdJ/mWo4rA4T
         o9Iupx6bQnVFuDizH0jFgowPkmjeCGzCmpw5a8tHNk/D8gRxwl1PDk435kAWyZNPuUOc
         MQBFh/RYmwaQWFSjscSlyz4gLCJOIMRcmKhMA=
MIME-Version: 1.0
In-Reply-To: <4DE9294B.3040501@freescale.com>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
	<4DE92675.6080908@freescale.com>
	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
	<4DE9294B.3040501@freescale.com>
Date: Fri, 3 Jun 2011 21:39:28 +0300
Message-ID: <BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
Subject: Re: [PATCH] lib: introduce strdup_from_user
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Timur Tabi <timur@freescale.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:34 PM, Timur Tabi <timur@freescale.com> wrote:
> Would it be better if I did this:

The point is data should cross kernelspace/userspace boundary only once.
