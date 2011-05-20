Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935960Ab1ETVMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:12:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34781 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878Ab1ETVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=w1Sw2Zw55pc9GvCf2rJVA5krcrKBxgmIv25PaDe7nKs5MIyi+lCMlMpWFqxk3PUZpF
         danvvW5vbjZNULdWVre8G9d40mr++zvaCg3mqTbl3tpyQCILBWGwIyaI2yxGyiFaCrhG
         uNnwAf9rU9O32QwuIhL70wj5vwOW7onx0ps/g=
MIME-Version: 1.0
In-Reply-To: <201105202224.56867.rjw@sisk.pl>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com>
 <201105202224.56867.rjw@sisk.pl>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 20 May 2011 14:11:45 -0700
X-Google-Sender-Auth: 0sETXGTuqTHCefGEodQhSVdT7cA
Message-ID: <BANLkTi=3yJS8NUzbAcwT0gzFqp-2AbSPqA@mail.gmail.com>
Subject: Re: Major 2.6.38 regression ignored?
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Luke-Jr <luke@dashjr.org>, chris@chris-wilson.co.uk,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Rafael J. Wysocki <rjw@sisk.pl>
> It is on the list of known regressions from 2.6.37, but we're not tracking
> them any more now that 2.6.39 is out.

Hopefully Chris is still tracking them, even if you aren't.

Chris? What other information can the affected person provide, or what
tests can he run to help close this out?
