Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab1ENCXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 22:23:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41968 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab1ENCXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 22:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JT4qOxWrompo3MdglRt8wyliw+8fWTqXWVT/sMFZMDUampSwUg1DnPqB8cOKIk3yAh
         Ervo4B4dlC0mxKf/HtmSw+3bNEEsPuwtGdi2tTPgdbzRFRBNTtopwSEly9eswplVXRmo
         YXGD1f6z9LlY2QSJ77du+hQKl8eoRuYvtetIU=
MIME-Version: 1.0
In-Reply-To: <1305329059-2017-6-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-6-git-send-email-andi@firstfloor.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 13 May 2011 22:23:30 -0400
Message-ID: <BANLkTimKjtns7oFNMTLbnbyAkKi679ui5A@mail.gmail.com>
Subject: Re: [PATCH 5/5] Hook up sysconf syscall for all architectures
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 19:24, Andi Kleen wrote:
>  arch/blackfin/include/asm/unistd.h     |    3 ++-
>  arch/blackfin/mach-common/entry.S      |    1 +

i wish more people would wire up new syscalls for arches ;)

i dont recall off the top of my head acking any other pending new
syscall which would cause a conflict, so:
Acked-by: Mike Frysinger <vapier@gentoo.org>

i generally wait for syscalls to hit mainline before i wire them up myself
-mike
