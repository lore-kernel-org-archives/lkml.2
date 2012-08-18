Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2HRTZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 15:25:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42243 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2HRTY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 15:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120818185528.GA250@x4>
References: <20120817171354.GA14046@kroah.com> <20120818060934.GA255@x4>
 <20120818163401.GA2013@kroah.com> <1345315025.10014.15.camel@joe2Laptop> <20120818185528.GA250@x4>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Aug 2012 12:24:34 -0700
X-Google-Sender-Auth: wKpJmEDhTzsTK_onFVVbhocoeKs
Message-ID: <CA+55aFw48y=bZQq12-ySBiDT=ef6Yuq=eh6HLo6TGqyEK2kPkw@mail.gmail.com>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 11:55 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> IOW:

Ack, that looks about right. Does that simple patch fix the issue for
you? Greg? You saw it too..

            Linus
