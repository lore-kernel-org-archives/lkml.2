Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2DJKGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:06:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37911 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2DJKF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:05:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAD2nsn3HSq7UXFPvDP6cW9XmGs43ATkChT43fTvd4LpgPgSYTw@mail.gmail.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
	<20120409010816.36244f17@xenia.leun.net>
	<CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
	<20120409122549.7469543a@xenia.leun.net>
	<20120409160322.6b7b8c67@xenia.leun.net>
	<CAD2nsn0n-VQ8ZOm69BNrbFv5HK3cdm+22yKrYprwoeFz-E2Uew@mail.gmail.com>
	<20120409172933.4ca4775a@xenia.leun.net>
	<CAD2nsn3HSq7UXFPvDP6cW9XmGs43ATkChT43fTvd4LpgPgSYTw@mail.gmail.com>
Date: Tue, 10 Apr 2012 15:35:58 +0530
Message-ID: <CAD2nsn0mk-Z=062ive7WhJKo2hxAunCyhn10FLebNwRPd-ip+A@mail.gmail.com>
Subject: Re: [ath9k-devel] 3.4-rc ath9k regression (Re: 3.3.1 ath9k regression)
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Michael Leun <lkml20120218@newton.leun.net>
Cc: Kelly Anderson <kelly@silka.with-linux.com>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        casteyde.christian@free.fr,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Peter Stuge <peter@stuge.se>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

revert patch is sent by Sujith
http://comments.gmane.org/gmane.linux.kernel.wireless.general/88543
got to fix unassociated idle case power save.

-- 
thanks,
shafi
