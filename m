Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0L3AcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 19:32:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46251 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0L3AcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 19:32:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ekzjCQS1Q4FJFwMylU44vwOu/VHHj1IHyQsLBL+6Ig55I6cLw1t5CqEBGpctOWF4zn
         Gnq/LLENTe2J7z65zzIkrBPoDXZnE/9brqP7qOpmUlFdFd76lVoyZJwOaBhKWXQv9X88
         bwPdR7LaSU10wGiPWzCn9nJn/+aZxi1BUMkQs=
Message-ID: <4D1BD308.4030103@lwfinger.net>
Date: Wed, 29 Dec 2010 18:32:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
Subject: Re: [Bug #22672] Regression in 2.6.37-rc1 for Intel 945 Graphics
 Adapter - bisected to commit e9e331a
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.F4G.VA8GNB@chimera>
In-Reply-To: <sV7shrPOroO.A.F4G.VA8GNB@chimera>
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22672
> Subject		: Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2010-11-11 01:56 (49 days old)
> References	: https://bugs.freedesktop.org/show_bug.cgi?id=31803
> 		  http://marc.info/?l=linux-kernel&m=128944001311444&w=2
> 		  http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg02235.html
> Patch		: https://patchwork.kernel.org/patch/359472/
> 		  https://patchwork.kernel.org/patch/359502/

Neither 2.6.37-rc8 nor the patches listed above fix my system.

Larry
