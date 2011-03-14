Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1CNFxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 01:53:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47790 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab1CNFw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 01:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jk3LNoTB2c1PD8wVuRePgmYSGPlHKtY2G1oC8DmXth8ulSc8Co/2UYqLe7mXbm07VG
         gACE7zOBfTYWefryxAZRdJGGaO44MoPacXrY79hFWp7F2c9xdrS7LTIxzlRViS75VUEt
         9nTjRqaUgyvYKTmihkTwwxghlBI8i0uBEbHZg=
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Indan Zupancic <indan@nul.nu>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
In-Reply-To: <3cc2c5c6fa6b3bd384017ae95a4241ab.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
	 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	 <201103111255.44979.arnd@arndb.de>
	 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	 <4D7AC0FE.8070806@gmail.com>
	 <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
	 <1299957736.2332.4.camel@koala>
	 <3cc2c5c6fa6b3bd384017ae95a4241ab.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 07:52:54 +0200
Message-ID: <1300081974.2332.14.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 02:38 +0100, Indan Zupancic wrote:
> > I had a program, actually a set of programs, which test a file-system.
> > And this set of programs needed such a feature quite a lot, to sync the
> > FS which is being tested and nothing else - for both performance reasons
> > and to put more stress to the FS under testing. We used -o remount, rw
> > for this - but this forced us to run under root.
> 
> You could use a tiny setuid root helper binary that does the remount trick.

Yes, but I think this is not elegant solution.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

