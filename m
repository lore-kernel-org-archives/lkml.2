Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1FIXIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:08:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37939 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1FIXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N9FXQcPFK6RLY8Zs2G36T48RwvKUQSFI6esJFWpWxolT+DhceEnmIff/R4Ctmaf9Ej
         aLoee+lBZjQbdC+F+xUwrrCrIaiA/fHOs5EMF4wq1hGXSmUHEHm3+p01WcN+FIpSb/Ul
         KNJI7aD6//sIip7zdyxIkG5UtTjkIq84EnG8k=
Date: Fri, 10 Jun 2011 01:08:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 2/4] nohz: Split extended quiescent state handling from
 nohz switch
Message-ID: <20110609230756.GH25771@somewhere.redhat.com>
References: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
 <1307329858-14999-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307329858-14999-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for all your reviews and acks, I'm resending
the v2 soon with your acks included.
