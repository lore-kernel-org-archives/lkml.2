Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0CVDZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:25:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:48656 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab0CVDZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:25:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=orTQdosR/u2vUyWnQ+Zt0PTN+LIiX2BREmSqX6FeLr6RGG1agNu9Si86oXbarsVsb
	bbuN2HXgq48+2WwWSnWgg==
Date: Mon, 22 Mar 2010 03:24:46 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
In-Reply-To: <hTwaxgnIZ2O.A.rhF.SQopLB@chimera>
Message-ID: <alpine.LSU.2.00.1003220319360.1726@sister.anvils>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.rhF.SQopLB@chimera>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
> Subject		: lockdep warning during elevator_switch
> Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Date		: 2010-01-31 23:55 (50 days old)
> References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4

Yes, it is still a regression 2.6.33.1 (though fixed in 2.6.34-rc1:
my guess is that it will be left as a regression in 2.6.33-stable,
since it only happens when you have chosen CONFIG_PROVE_LOCKING=y).

Hugh
