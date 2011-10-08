Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1JHTIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 15:08:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64396 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1JHTID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 15:08:03 -0400
MIME-Version: 1.0
In-Reply-To: <1317185489.19340.22.camel@Joe-Laptop>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com> <1316725066.29447.16.camel@Joe-Laptop>
 <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com>
 <1317166589.19340.14.camel@Joe-Laptop> <CAJfuBxyZ63mi_onv8uWc3MCGgKDPfQMOgUOT7isJ-hA=o7sfqA@mail.gmail.com>
 <1317185489.19340.22.camel@Joe-Laptop>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 8 Oct 2011 21:07:42 +0200
X-Google-Sender-Auth: XBL3V23GRIFzzd4TsA11kZen5FM
Message-ID: <CAO+b5-phx1S5cC91Czjhmym_tAWVGwqaBavhSnwHcuKaK662ag@mail.gmail.com>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for dynamic_pr_debug
To: Joe Perches <joe@perches.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, jbaron@redhat.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 6:51 AM, Joe Perches <joe@perches.com> wrote:
> I think all of the '#define pr_fmt(fmt) KBUILD_MODNAME ": "'
> are effectivly useless and I will eventually delete them.
>
> The printk subsystem should look up the module name and
> prefix them to the printk akin to how the dynamic_debug
> system does.  Except the module name should be a singleton.

Shouldn't pr_*() equivalents be introduced for sdev_printk(),
scmd_printk(), starget_printk() and shost_printk() before elimination
of pr_fmt() can start ?

Bart.
