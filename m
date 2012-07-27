Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2G0V26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:28:58 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:48905 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2G0V25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:28:57 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai1OAL8HE1BV5qoUPGdsb2JhbABFhQwihH6vKRkBAQEBNzSCIAEBBAE6HCMQCAMOOBQlChqIGgq7JBSLVoV6YAOVR4VrjQSBXQ
X-IronPort-AV: E=Sophos;i="4.77,669,1336341600"; 
   d="scan'208";a="383911274"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 27 Jul 2012 23:30:50 +0200
To: Guenter Roeck <linux@roeck-us.net>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (applesmc) Decode and act on
 read/write status codes
Message-ID: <20120727213050.GA1099@polaris.bitmath.org>
References: <1343412766-552-1-git-send-email-rydberg@euromail.se>
 <20120727210337.GA11324@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727210337.GA11324@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As I mentioned in a previous mail, backporting e70acc100 by itself is
> > not a good idea, but together with this patch it should be ok.
> > 
> I think the patches should mature a bit in mainline. We can decide in a month
> or so if we want to backport them to previous releases.

Yes, sorry, that was what I meant - backporting "at all". :-)

Thanks,
Henrik
