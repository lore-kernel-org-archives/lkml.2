Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0GJBpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 21:45:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0GJBpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 21:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IuYOcoSIj+2Os6qfwzQI0bchQ9DHbUfD5jtPaNqyvtaququITl9acgR0y0l3c50xR5
         fQN3J9IfL5HF5Oogag+MVus/Y4n6GnU9v1u5hNTtKB0b2ESEew0QMbyK7OjmNX0caxXu
         Rb9YTv7gWegtSpNVuzsm2ec89OI2ykAtXNLfw=
Date: Sat, 10 Jul 2010 03:45:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #15805] reiserfs locking
Message-ID: <20100710014504.GC5269@nowhere>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera> <Hc02ROPrUsG.A.vs.ls7NMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Hc02ROPrUsG.A.vs.ls7NMB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 02:33:24AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15805
> Subject		: reiserfs locking
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2010-04-15 21:02 (86 days old)
> Message-ID	: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127136535323933&w=2
> Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>


It's a duplicate of 16334. Or rather 16334 is a duplicate of this
but the discussion about the issue was more developped in 16334.

Anyway this is not a regression (at least not recent) and the fix
from Al is in the vfs tree in the for-next branch on commit
6c2bdaf089a3876226893fab00dd83596c465ad2
"Fix reiserfs_file_release()"

Thanks.

