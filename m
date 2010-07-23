Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab0GWUgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:36:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48088 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0GWUgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U8hisP7e5K5I3TRygScBnv8+VxsIbA/fRIwssT5S2HPDINEOQYznM52F+Ag0IDsXmU
         /Puj3uw2veEThvGPWJXO8VRRHoUyIuL618CvAo3+y8GruvOXBB6vPf8OCXMS+mv5uCrR
         S+iNW1vS1x/S6AnGrR3cguWPelNJ8M/hYvYNo=
MIME-Version: 1.0
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
Date: Fri, 23 Jul 2010 22:36:12 +0200
Message-ID: <AANLkTimK4XaXLNJtSFEsy3wygRK02BcLK=OZDJfAW63t@mail.gmail.com>
Subject: Re: 2.6.35-rc6: Reported regressions from 2.6.34
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 1:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16372
> Subject         : Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
> Submitter       : Torsten Kaiser <just.for.lkml@googlemail.com>
> Date            : 2010-07-11 19:56 (13 days old)
> Message-ID      : <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127887822407672&w=2

I just installed 2.6.35-rc6 and can confirm, that this bug is fixed.

Thanks!

Torsten
