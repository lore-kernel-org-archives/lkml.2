Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0H3AkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:40:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55313 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0H3AkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gZvfEX1USxnHpMrTo17dQCZa9fIGlXu2el1KMHnid6sO8PLWOj4UOLFQmcyPwJAEoi
         96P2Li55AsXrKi3BnPRFd014+NlbbkCwpcHsetLvdiLQsVtPmtCDZvl8sk9agOolKq/N
         gQJHkgej/5F6A1IccDnoN7WFswAKWWfz6FSTg=
Message-ID: <4C7AFE2C.1080204@lwfinger.net>
Date: Sun, 29 Aug 2010 19:41:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        archman <spermmail001@yahoo.com>
Subject: Re: [Bug #16505] 2.6.34.2 breaks b43
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.h7B.DdueMB@chimera>
In-Reply-To: <ByD_7B96czP.A.h7B.DdueMB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 06:13 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16505
> Subject		: 2.6.34.2 breaks b43
> Submitter	: archman <spermmail001@yahoo.com>
> Date		: 2010-08-03 23:53 (27 days old)
> Handled-By	: Larry Finger <Larry.Finger@lwfinger.net>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=27335

This one was fixed in 2.6.34.3. Mainline was OK - only the patches to stable
were affected. The bug should be closed.

Larry

