Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab1CSRHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 13:07:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61034 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab1CSRHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 13:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=aDTj/rRjI+nc5B1o35OV3Gub1J4CoVzkFpP4DKwB8QGndXUC328ovLicDGvya3JJpZ
         0LAn5zh21s5RDqUkwd2lIyr5p6KOQ5VOT2g6hbEAZDEn8ja5kV/vSuklapg5hEEK+9wY
         ozG9KBZlvc2Dbb4P6xaQIcAcBtve94UId0tgw=
MIME-Version: 1.0
In-Reply-To: <20110319091946.GA11644@riccoc20.at.omicron.at>
References: <1300471877-3544-1-git-send-email-vapier@gentoo.org> <20110319091946.GA11644@riccoc20.at.omicron.at>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 19 Mar 2011 13:06:49 -0400
X-Google-Sender-Auth: UJkigrBKs1jMY0mYKfWJb2aPqqk
Message-ID: <AANLkTikvrEHDZyNXQRBV8TVufEGodmD0WtGn=EoHChqM@mail.gmail.com>
Subject: Re: [PATCH 00/32] Blackfin updates for 2.6.39-rc0
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 05:19, Richard Cochran wrote:
> On Fri, Mar 18, 2011 at 02:11:17PM -0400, Mike Frysinger wrote:
>> Philippe Gerum (3):
>>   Blackfin/ipipe: upgrade to I-pipe mainline
>>   Blackfin/ipipe: fix deferred pipeline sync for the root stage
>>   Blackfin/ipipe: restore pipeline bits in irqflags
>
> So, is adeos/ipipe specific code being considered for acceptance into
> mainline Linux these days?

we dont mind the Blackfin pieces being integrated directly.  makes our
lives easier considering we asked for said work.  but i dont think
this has any bearing on common code.
-mike
