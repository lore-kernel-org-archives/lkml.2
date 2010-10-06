Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab0JFOwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:52:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41979 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab0JFOwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=DgG5/T+ZwfO09skgjhYz3kfTlWgStTEvZzMbBYRKzVaf01GIVAUh8wREkhWSYNK60u
         n8atb0ab5RzQeMeX/gIvowhIT8CnH/za2OUJKFUqVpaI8W4Rcu/tysv4O1E7HfSa52zE
         xpG+A7BbEBByNYDvXqAzmzRml1RGT6VUbIwPM=
MIME-Version: 1.0
In-Reply-To: <1286349233-31721-1-git-send-email-thomas@wytron.com.tw>
References: <1286349233-31721-1-git-send-email-thomas@wytron.com.tw>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 6 Oct 2010 10:51:39 -0400
X-Google-Sender-Auth: JcbNuPYYaRphgfD7l6renR7rqdk
Message-ID: <AANLkTikN_B-xq=Ge1gx-T5356K5ULd7u11y-mmS=BXMO@mail.gmail.com>
Subject: Re: [PATCH] gen_init_cpio: remove leading `/' from file names
To: Thomas Chou <thomas@wytron.com.tw>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 03:13, Thomas Chou wrote:
> When we extracted the generated cpio archive using "cpio -id" command,
> it complained,
>
> cpio: Removing leading `/' from member names
> var/run
> cpio: Removing leading `/' from member names
> var/lib
> cpio: Removing leading `/' from member names
> var/lib/misc
>
> It is worse with the latest "cpio" or "pax", which tries to overwrite
> the host file system with the leading '/'.

seems to work as intended on Blackfin systems, and i cant see any
reason to require the leading slash, so:
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
