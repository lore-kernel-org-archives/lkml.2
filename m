Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1CXJ2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:28:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47449 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab1CXJ2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AwzWzevY7RKaCsOFcZaM+myobOMW1Ovfcz3EtCg4cWCb1kQE+ll6WBgweszejyYz72
         n6y99LKeVaLI/7UoSEZjHi+VxshFuvNDbgexpU/g+hRtbzB8oaVRc1JBV/DdqvOXk0dn
         7gGrFsFvA1jj8j4Fc9p515CEmqTWWWDLW+rVU=
MIME-Version: 1.0
In-Reply-To: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
References: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
Date: Thu, 24 Mar 2011 11:27:59 +0200
X-Google-Sender-Auth: BOc2EWpaREj4kO9KqMW76MTZL7E
Message-ID: <AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
Subject: Re: kmemleak for MIPS
From: Daniel Baluta <dbaluta@ixiacom.com>
To: naveen yadav <yad.naveen@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I want to check kmemleak for both ARM/MIPS. i am able to find kernel
> patch for ARM at
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg11830.html.
> But I could not able to trace patch for MIPS.

It seems that kmemleak is not supported on MIPS.

According to 'depends on' config entry it is supported on:
x86, arm, ppc, s390, sparc64, superh, microblaze and tile.

Cătălin, can you confirm this? I will send a patch to update
Documentation/kmemleak.txt.

Also, looking forward to work on making kmemleak available on MIPS.

thanks,
Daniel.
