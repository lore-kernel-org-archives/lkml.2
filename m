Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1EPTrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:47:39 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:50091 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1EPTrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:47:37 -0400
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Ben Hutchings <bhutchings@solarflare.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305574680.3456.33.camel@localhost.localdomain>
References: <1305574128.3456.23.camel@localhost.localdomain>
	 <1305574518.2885.25.camel@bwh-desktop>
	 <1305574680.3456.33.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 16 May 2011 20:47:33 +0100
Message-ID: <1305575253.2885.28.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2011 19:47:36.0608 (UTC) FILETIME=[1B388200:01CC1402]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18138.005
X-TM-AS-Result: No--17.633200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 12:38 -0700, Shirley Ma wrote:
> On Mon, 2011-05-16 at 20:35 +0100, Ben Hutchings wrote:
> > Sorry, bit 31 is taken.  You get the job of turning features into a
> > wider bitmap.
> 
> :) will do it.

Bear in mind that feature masks are manipulated in many different
places.  This is not a simple task.

See previous discussion at:
http://thread.gmane.org/gmane.linux.network/193284
and especially:
http://thread.gmane.org/gmane.linux.network/193284/focus=193332

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

