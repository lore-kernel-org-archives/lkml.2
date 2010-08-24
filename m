Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0HXW3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:29:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47014 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab0HXW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=d488uH0Fia279nsUk529RiHjuXiN48vsnALrv24czhViN5etakGpd/vkxUdbRqR5Em
         qYYc0ee3DIxZrQkHfX5IPE5CRXMMs4KWOwCZYZPGWoy52zRgauXof3CbMEiUD3jRJHSw
         VP9yYmSzlq5EOVHOhsIXarEbIvYHqPc/N9QoE=
MIME-Version: 1.0
In-Reply-To: <20100824220241.25661.22127.stgit@warthog.procyon.org.uk>
References: <20100824220241.25661.22127.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 24 Aug 2010 18:28:59 -0400
X-Google-Sender-Auth: 0XLxNH88uCXPHPwiUuPefulri3Q
Message-ID: <AANLkTinrjQ-NGPQQvpjBxCXcBAHWEqTAMAH34xL-eHj3@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] Blackfin: Fix hamming weight functions
To: David Howells <dhowells@redhat.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 18:02, David Howells wrote:
> Fix the hamming weight functions to support the const variants in
> asm-generic/bitops/const_hweight.h.

mmm i sent a pull request to Linus for this already ... you can find
the same fix in my for-linus branch
  http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=shortlog;h=refs/heads/for-linus
-mike
