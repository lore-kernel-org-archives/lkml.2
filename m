Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2DWAz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 20:55:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab2DWAz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 20:55:56 -0400
Subject: Re: [PATCH] C6X: add support to build with BINFMT_ELF_FDPIC
From: Mark Salter <msalter@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>
Date: Sun, 22 Apr 2012 20:55:43 -0400
In-Reply-To: <20120422213534.GA6570@merkur.ravnborg.org>
References: <1334958476-6296-1-git-send-email-msalter@redhat.com>
	 <CAMjpGUe+CMkHP7owZym_6c2RDvgLzj8t+ZpLBuqQ0euk+ArV2Q@mail.gmail.com>
	 <1335129679.12741.4.camel@deneb.redhat.com>
	 <20120422213534.GA6570@merkur.ravnborg.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1335142545.12741.8.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-22 at 23:35 +0200, Sam Ravnborg wrote:
> Allow TMS320C6X for a sinel relase along with C6X - and drop it
> when all users outside your arch has switched over.

I'm not sure we need to carry TMS320C6X for even a single release. As
Mike pointed out, there are few references, actually no references
right now, so now would be a good time to correct it. I'll make a patch
to do just that.

--Mark


