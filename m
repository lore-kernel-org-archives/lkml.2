Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0HQUyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 16:54:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47919 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0HQUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 16:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IlUQbEyxncf2ybwizaGfGkDwzDbfuT4Rkixnbulnwh15ej4qWP4Gv+KA0DSksiF/3D
         PRaiQloBKtFQ8j1BhD+dyfkpJG5i5NQwuoTq7fSl2P925xKGxA2Hoh76se6miYvHFIA+
         S6qg+0gpES31QSXPQ9mWHNwHUpRhgdRyXmGj0=
MIME-Version: 1.0
In-Reply-To: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
Date: Tue, 17 Aug 2010 22:54:38 +0200
Message-ID: <AANLkTimLcgnob81vcsMiJaJhz=ruymE8-XA=XvxnY-GD@mail.gmail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: Andrea Gelmini <andrea.gelmini@gmail.com>
To: trapdoor6@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/17 trapDoor <trapdoor6@gmail.com>:
> Hello,
> The merge window is closed so it's time to hunt for bugs. I've got
> one, please find details below.

Same problem here...
But I've made no bisecting.

Thanks a lot,
Andrea
