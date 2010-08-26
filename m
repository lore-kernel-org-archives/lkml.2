Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0HZTjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:39:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42513 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab0HZTi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=vjH3/d1upuLuVdx8ZmN47T9NpEe/lHbcwncKY61kdfTRcDhZaU1zlubXL8pLwEC1QR
         zy8CGYZ8nXbYs9XcbjGk+nW2GXxbTFdov56CZG/CXLYZno7PCZDhSrE4kIkGxLASexN9
         pHAeg07L40ZMu6wn0Om0970+m4QRtsYgBYgEI=
MIME-Version: 1.0
In-Reply-To: <20100826141115.11132.52122.stgit@warthog.procyon.org.uk>
References: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk> <20100826141115.11132.52122.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 26 Aug 2010 15:38:37 -0400
X-Google-Sender-Auth: T9bn5kBtBr1ci5ZOb7fvhnfrMh4
Message-ID: <AANLkTinxwf6kY6hCnUn=ATSYFutCAeSJQ1pgUj11UfD4@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 2/7] Blackfin: Don't redefine
 blackfin serial port symbols
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 10:11, David Howells wrote:
> Various Blackfin machine-specific headers override Blackfin serial port
> symbols from the <asm/bfin_sport.h> header file with exactly the same values.
>
> Remove the duplicates in favour of the master header.

we've got a local patch doing pretty much the same thing, but it's
waiting on driver patches being applied.  so once those are all set, i
can push up the Blackfin one.
-mike
