Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1BMI6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 03:58:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63124 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1BMI63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 03:58:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ZAMI6RXGJ5yBHimN2LLPP5jMpFo6OKW+bUnARXC5S486EYeG0UvTnAhfPThy5iOyMR
         TUfqKcbs4smn8vkNsJXDJ8zujBaeu46myILv82wEjJ2tJAzbi5W69KuvP04fBBe/CPmN
         itgRQzPHu5LYsTdpHOK8O7eThOw3NoJsparhQ=
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #28852] [KMS] radeon artifacts when switched to graphics during boot
Date: Sun, 13 Feb 2011 09:58:22 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc4+; KDE/4.6.0; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Deucher <alexdeucher@gmail.com>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <8H3lez1sawF.A.4jG.FAxVNB@chimera>
In-Reply-To: <8H3lez1sawF.A.4jG.FAxVNB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102130958.22668.oldium.pro@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011 00:05:22 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the
> tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28852
> Subject		: [KMS] radeon artifacts when switched to graphics during boot
> Submitter	: Oldřich Jedlička <oldium.pro@seznam.cz>
> Date		: 2011-02-10 21:11 (3 days old)
> Handled-By	: Alex Deucher <alexdeucher@gmail.com>

Status update - some patches that fix the issue exist already, Alex is 
investigating the best fix.

Oldrich.
