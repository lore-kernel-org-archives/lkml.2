Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab2DEGQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:16:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45709 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2DEGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120404235104.682cfad3@xenia.leun.net>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
Date: Thu, 5 Apr 2012 11:46:36 +0530
Message-ID: <CAD2nsn0iRjxgY=EFoX2t5fFQ2_7X71WAax2M-spO=b+kBF15Fg@mail.gmail.com>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Michael Leun <lkml20120218@newton.leun.net>
Cc: casteyde.christian@free.fr, Kelly Anderson <kelly@silka.with-linux.com>,
        Ben Greear <greearb@candelatech.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Surprise, surprise: This (what I saw) really only happens in 3.3.1 -
> 3.4-rc1 works also when the patch is in place.

thanks, if the other users can confirm it the issue is resolved, we
can close the thread, otherwise i would spend time to recreate and fix
it.

>
> Would never have expected that...
>
>
> --
> MfG,
>
> Michael Leun
>



-- 
thanks,
shafi
