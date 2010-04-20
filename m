Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0DTGkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:40:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2187 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0DTGko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HOzf+gawHAg56yQr4IZoiLhB57UXKp/1pgSEIxh8WygpdV1g+N0QIpZgW8HluYmKjh
         +ssjHBMsumlO6uuOVs6eM87mVL4iM8DCQTWHnhItSoaOjTPc4B52nLyTx7F8b5EF3UQW
         FQezmcaoTr8ZxUizMlXQlrjv7o/QVffjDfrrQ=
MIME-Version: 1.0
In-Reply-To: <YeFfFNFyTSF.A.mIB.aSSzLB@tosh>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.mIB.aSSzLB@tosh>
Date: Tue, 20 Apr 2010 09:40:41 +0300
X-Google-Sender-Auth: 75364292086a6f4a
Message-ID: <z2h84144f021004192340z98fcc1c5m1544233f2ea6c0c4@mail.gmail.com>
Subject: Re: [Bug #15601] [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "michael-dev@fami-braun.de"@ogre.sisk.pl,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 6:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15601
> Subject         : [BUG] SLOB breaks Crypto
> Submitter       : michael-dev@fami-braun.de
> Date            : 2010-03-15 13:39 (36 days old)
> Message-ID      : <4B9E38AF.70309@fami-braun.de>
> References      : http://marc.info/?l=linux-kernel&m=126866044724539&w=2

Ping?
