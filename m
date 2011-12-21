Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1LUQnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:43:03 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:47071 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753326Ab1LUQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:42:54 -0500
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 11:42:53 EST
Date: Wed, 21 Dec 2011 11:32:13 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net
Subject: Re: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
Message-ID: <20111221163213.GA17116@elliptictech.com>
References: <201112210054.46995.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112210054.46995.rjw@sisk.pl>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-21 00:54 +0100, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 3.0 and 3.1 for
> which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
> 
> If you know of any other unresolved regressions from 3.0 and 3.1,
> please let us know either and we'll add them to the list.  Also,
> please let us know if any of the entries below are invalid.

i915 HDMI log spam, reported against -rc1:

  http://permalink.gmane.org/gmane.linux.kernel/1212638

remains present in mainline.  The latest patches (afaik) were posted
earlier this month:

  Subject: Intel HDMI ELD fixes v2
  http://permalink.gmane.org/gmane.linux.kernel/1226920

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

