Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab0LTLXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 06:23:42 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:64679 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0LTLXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 06:23:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=drZAOjVusjPDTStjrXtKIdWOcWLADmDYVGGn4ccwyUE5dtqy0ZNp8vLwzIOkDDwgFr
         /3s80v0zf70eoII7fPurKJBVgUkimVttxz2OdcRiWyADnzy0w4KXc88VClseQ0PPpElA
         muCpt7DPLcm/N0aC/idkw4un9sN2rsDl5KS44=
Subject: Re: mtd: fix CONFIG_MTD_COMPLEX_MAPPINGS=n compile
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Lunz <lunz@acm.org>
Cc: Anatolij Gustschin <agust@denx.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <20101219190720.GA16710@falooley.org>
References: <20071227181524.GA19051@falooley.org>
	 <20071228174853.GA4252@uranus.ravnborg.org>
	 <20101207072919.GA8511@falooley.org>
	 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	 <20101207182012.GA10546@falooley.org> <1292343878.2538.80.camel@localhost>
	 <20101214195124.GA6010@falooley.org> <20101216230110.65156c55@wker>
	 <20101217042759.GA3148@falooley.org> <1292777276.2140.1.camel@koala>
	 <20101219190720.GA16710@falooley.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 13:23:36 +0200
Message-ID: <1292844216.13362.19.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 14:07 -0500, Jason Lunz wrote:
> You should also drop the changes that
> 7bc3265a9e9a09d6a9a3cfaaf53ccf3af5271a93 made to drivers/mtd/mtdchar.c -
> there's no point changing that when mtdchar is disabled on ARCH=um.

Ok, could you please re-sent the final patch with the commit message
etc?

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

