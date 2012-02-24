Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2BXUZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:25:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39492 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab2BXUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:25:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.180.99.65 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224163151.GA8083@kroah.com>
References: <E1S0xkw-0005Mj-4q.carasin-berlogue-mail-ru@f264.mail.ru>
	<20120224163151.GA8083@kroah.com>
Date: Fri, 24 Feb 2012 15:25:44 -0500
Message-ID: <CA+5PVA7p3eZnornsNa_dLZ9YLTy6WuFO3wpGbCZD4O9oFL=s=w@mail.gmail.com>
Subject: Re: Take a look to this bug, please
From: Josh Boyer <jwboyer@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: =?KOI8-R?B?68nSyczMIPLV08nOz9c=?= <carasin.berlogue@mail.ru>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 11:31 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> Also, have you tried the latest 3.3-rc4 kernel, it should have solved
> this problem.

Could you perhaps elaborate on that part a bit?  I don't see any mention of
RV420/520/720 support in samsung-laptop.c.  The last addition was for X520 and
that is already in the kernel being run in the bug report.

josh
