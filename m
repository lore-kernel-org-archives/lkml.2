Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2DWDFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 23:05:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55100 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2DWDFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 23:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <1335142545.12741.8.camel@deneb.redhat.com>
References: <1334958476-6296-1-git-send-email-msalter@redhat.com>
 <CAMjpGUe+CMkHP7owZym_6c2RDvgLzj8t+ZpLBuqQ0euk+ArV2Q@mail.gmail.com>
 <1335129679.12741.4.camel@deneb.redhat.com> <20120422213534.GA6570@merkur.ravnborg.org>
 <1335142545.12741.8.camel@deneb.redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 22 Apr 2012 23:04:53 -0400
Message-ID: <CAMjpGUd+m5sQbTVUrOi7vZ6q+9JZHPMKoG10ZNyHpXzkGqm7TA@mail.gmail.com>
Subject: Re: [PATCH] C6X: add support to build with BINFMT_ELF_FDPIC
To: Mark Salter <msalter@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 20:55, Mark Salter wrote:
> On Sun, 2012-04-22 at 23:35 +0200, Sam Ravnborg wrote:
>> Allow TMS320C6X for a sinel relase along with C6X - and drop it
>> when all users outside your arch has switched over.
>
> I'm not sure we need to carry TMS320C6X for even a single release. As
> Mike pointed out, there are few references, actually no references
> right now, so now would be a good time to correct it. I'll make a patch
> to do just that.

thx!
-mike
