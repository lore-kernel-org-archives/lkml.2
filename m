Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1ADIkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:40:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42257 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1ADIke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZmaKSiCd2QmLVlJK3hxreMcbQjn61W2XVo6r9eBUG1bfSoLvmliAF3ppSdqS1V+XD4
         d6jNzl2u+TDadZZBYQYTh+miDnmk9dqAQOuwWFht0q9IDpnjqxZ4ZtqqAlkBqC+JPPqq
         wVDB+OiAOhJ9XOCNqwu1RswZFBEPoLxq7MrZA=
Date: Tue, 4 Jan 2011 09:40:23 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
Subject: Re: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20110104084023.GB4563@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
 <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
 <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
 <1294087466.2571.89.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294087466.2571.89.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 12:44:26PM -0800, John Stultz wrote:
> Richard: Maybe this is a good thing to think about for clock_adjtime? If
> we are adding a new syscall, maybe we should make sure we clean up some
> of the old syscalls issues? It does add a good bit of complexity, as the
> idea of clock_adjtime being a multiplexing adjtimex was nice and simple.
> We'd also have to review the mode usage to see if multi-mode adjustments
> in a single call are all that common or not.

So, is the NTP source code the documentation of the kernel interface?

Thanks,
Richard
