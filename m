Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0LAQxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:53:20 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53700 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0LAQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=LJmEDUdzD1mI5cCtB1N1WH82XKG+aE1IYauCsKSO5SEnosOp2B3NqIzrhC4hFaocGi
         UZLQQFiNf3wdbKR1PP2keSaZVnYwOKI9Lrqw/DorIG5myScBvAs+MZqe2feQOHQde2xs
         1/zlSj+4henN2RXWoD/osvzHhSWvAl0JWK+QA=
MIME-Version: 1.0
In-Reply-To: <20101201132437.GA32555@linux-mips.org>
References: <AANLkTi=4gtEC9fZyvc9g6uHecvjPrr0dDc==KsDOvq2Q@mail.gmail.com>
	<20101201132437.GA32555@linux-mips.org>
Date: Wed, 1 Dec 2010 22:23:17 +0530
Message-ID: <AANLkTimEb32MAC_KUm+ZjXntJqiE=_OPbO6C3Se4MFEN@mail.gmail.com>
Subject: Change of Default kernel page size i.e 4KB
From: naveen yadav <yad.naveen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

 I have few drivers and very big application running on ARM and MIPS target.
 I want to check the performance by changing the page size ie.
 8K, 16K, 32K etc.

 Is it possile, If yes then what all care i need to take .

thanks
