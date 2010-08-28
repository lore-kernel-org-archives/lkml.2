Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0H1Pqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:46:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63601 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0H1Pql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type;
        b=a6OEy4vGVI3ARvKMpjdhXr85ncacF13Wnbi1RZ2Eo//PUe20OZBCLgZQmxuJzEOT3P
         pBl/KLoYtXqJTUBjNiVVSe+OON/DrAEO2oTRpaeF4WXi7eLeVI4Pi+1Bi8oZTGp70Epu
         kxwtoYg8l8wmrNSkG1u4CZaSKbyK2DjzA0tK0=
MIME-Version: 1.0
In-Reply-To: <20100828110712.GA25785@liondog.tnic>
References: <20100828110712.GA25785@liondog.tnic>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 28 Aug 2010 11:46:20 -0400
X-Google-Sender-Auth: KLyf8Nuyipej3RIx4lD1akoZ8QI
Message-ID: <AANLkTi=ceCkr=bP3m3fc9NtQ8GJo8VV90t7=_nyp3cH+@mail.gmail.com>
Subject: Re: [PATCH] misc devices: Do not enable by default
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andres Salomon <dilinger@collabora.co.uk>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 07:07, Borislav Petkov wrote:
> Do not enable this Kconfig menu by default since it contains devices not
> present on the majority of systems.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
