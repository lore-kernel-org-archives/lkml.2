Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0CVC4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 22:56:07 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:37208 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0CVC4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 22:56:05 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 22:56:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H++ZQmRQFFXVgns8/f/zNirCjzVggUkHNaoXalfNwfQ7eLfcapxi3LSilZmtD99FK8
         fqaemwTdfpYlgwNdouWgjSo3gM4uO10XIscwTHk5s/kRn4vsHDer958LewgZk1tyrwvW
         s6l/AFlIGKSzUOshxh2X0wdDRI6ZEv9Wd4GTo=
MIME-Version: 1.0
In-Reply-To: <hTwaxgnIZ2O.A.DEE.3OopLB@chimera>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.DEE.3OopLB@chimera>
From: =?UTF-8?B?UkFMT1ZJQ0gsIEtyaXN0w7Nm?= <kristof.ralovich@gmail.com>
Date: Sun, 21 Mar 2010 22:47:57 -0400
Message-ID: <5712ce4f1003211947i1a2ac84ch269885f7c2888c4f@mail.gmail.com>
Subject: Re: [Bug #15392] The kernel does not start up.
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue is still there with 2.6.33-rc1, 2.6.33 and 2.6.33.1 too.

Kristof

On Sun, Mar 21, 2010 at 16:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15392
> Subject         : The kernel does not start up.
> Submitter       : Kristóf Ralovich <kristof.ralovich@gmail.com>
> Date            : 2010-02-25 06:52 (25 days old)
>
>
>
