Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1A0Tmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:42:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47803 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A0Tmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=U7jHPoWG8IQW9Z+UpQMM9i293pXG2+qGhN7WXcata253+IOcj91KYamFcs8+vtP6/s
         NtigxeXj1ONYhOuYN1uW7LYQZPxzZQML7QUpR7dGeMqCmNXQn7SRbxqYat6sZggF1SUa
         CT/VIgV0gdi20QpgTMXIE3typMrbd5CpW7di0=
MIME-Version: 1.0
In-Reply-To: <20110127145931.23248.33917.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost> <20110127145931.23248.33917.stgit@localhost>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 27 Jan 2011 14:42:29 -0500
X-Google-Sender-Auth: lN3wiSeajS-dD2YroFwtVpWSeyU
Message-ID: <AANLkTi=us5cofeeqaN1jbcnaP8mRR_Cnhf+qE4Y4-QA+@mail.gmail.com>
Subject: Re: [PATCH v2 08/20] blackfin: switch from do_timer() to xtime_update()
To: Torben Hohn <torbenh@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 09:59, Torben Hohn wrote:
> xtime_update() takes the xtime_lock itself.

looks straightforward enough ...
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
