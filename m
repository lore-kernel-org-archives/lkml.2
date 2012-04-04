Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2DDVvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:51:32 -0400
Received: from serv04.lahn.de ([213.239.197.57]:36768 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab2DDVvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:51:31 -0400
Date: Wed, 4 Apr 2012 23:51:04 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: casteyde.christian@free.fr, Kelly Anderson <kelly@silka.with-linux.com>,
        Ben Greear <greearb@candelatech.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
Message-ID: <20120404235104.682cfad3@xenia.leun.net>
In-Reply-To: <CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
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
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012 20:33:22 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> Hi,
> 
> >> I've trouble with db6a6a78d8602964c9dfb1d8ce18daefd92da0a7 /
> >> c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to
> >> full-sleep on PS idle also.
> 
> with a basic analysis the commit under question seems to be logically
> correct, let me soon come with some idea or root cause why it may be
> happening

Surprise, surprise: This (what I saw) really only happens in 3.3.1 -
3.4-rc1 works also when the patch is in place.

Would never have expected that...


-- 
MfG,

Michael Leun

