Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0KSO5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:57:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0KSO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uqHcVqGFkY4Ylfgx4YmEylul4UReNjIBz39xqtbhV6gUYqko2zKgjSdOm5Hvjbykne
         E+JW5uLqn0MNzhAIpMtDCc6DkkbmHElWWeQnYDX8YqdLro29lLwoySkH6jFJUT0xi8fe
         aUhw7JZ7i8euc/sOqXmeRoKpQ9vBzsXpbCVR4=
Date: Fri, 19 Nov 2010 15:56:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Michael Stefaniuc <mstefani@redhat.com>
Subject: Re: [Bug #21332] Regression in single stepping over hardware
	breakpoint (Wine)
Message-ID: <20101119145651.GB5558@nowhere>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera> <t78YtCSuOqN.A.gEG.I4b5MB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t78YtCSuOqN.A.gEG.I4b5MB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:53:38AM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21332
> Subject		: Regression in single stepping over hardware breakpoint (Wine)
> Submitter	: Michael Stefaniuc <mstefani@redhat.com>
> Date		: 2010-10-27 23:41 (23 days old)
> First-Bad-Commit: http://git.kernel.org/linus/0c4519e825c9e2b6a8310deff8582f8c35bfbba9


The fix is in:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
	perf/urgent

6c0aca288e726405b01dacb12cac556454d34b2a
("x86: Ignore trap bits on single step exceptions")

And should reach mainline soon.

Thanks.

