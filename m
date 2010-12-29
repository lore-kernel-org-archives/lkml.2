Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0L2Xbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:31:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37152 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab0L2Xb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:31:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mZxV0vLXwLUcCvG4Ar2gt3JBWsB57L++xHRmd4co+/3rZBKh4ZHr44pkLPh46/bqcQ
         neUBvW237WzXPUcGGwRmh8p3ywVQURfMm2V+JUyye3X0SMirS/MTDhGOyJnglHFd8leL
         HXP49mJfRnSeS4sXkw/l1Yo1lgEY6fiGlOiV0=
Message-ID: <4D1BC4CC.6060700@lwfinger.net>
Date: Wed, 29 Dec 2010 17:31:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Bug #22562] Regression in 2.6.37-rc1 - logs spammed with "unable
 to enumerate USB port" - bisected to commit 3df7169e
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.JLH.iA8GNB@chimera>
In-Reply-To: <sV7shrPOroO.A.JLH.iA8GNB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2010 05:06 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22562
> Subject		: Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2010-11-02 22:32 (58 days old)
> First-Bad-Commit: http://git.kernel.org/linus/3df7169e73fc1d71a39cffeacc969f6840cdf52b
> Message-ID	: <4CD09166.4060202@lwfinger.net>
> References	: http://marc.info/?l=linux-kernel&m=128873713207906&w=2

It is still in 2.6.37-rc8. I got some debugging tips from Alan Stern, but have
not had time to follow-up. I hope/need to make some progress before 2.6.37 is
released.
