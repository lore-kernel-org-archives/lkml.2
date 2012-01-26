Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2AZRst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:48:49 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:44617 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2AZRss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:48:48 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuZSAMeRIU9V5qrvPGdsb2JhbABCiVCkexkBAQEBNzKBcgEBBAE6HCMFCwgDRhQlChqIDwK4AxOJDAMKAwsFBgQnBQELAggBAgECgmoJAwICBhsChAZjBJUehWeMbA
X-IronPort-AV: E=Sophos;i="4.71,574,1320620400"; 
   d="scan'208";a="258832513"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 26 Jan 2012 18:48:43 +0100
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] applesmc: Silence uninitialized warnings
Message-ID: <20120126174843.GA5088@polaris.bitmath.org>
References: <1327576121-2073-1-git-send-email-rydberg@euromail.se>
 <1327597937.2649.216.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327597937.2649.216.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That was an annoying warning .. I checked the code several times by now
> to make sure it is not real. Good idea to fix it.
> 
> Applied to -next for now. Linus did not (yet) accept my last set of
> patches, so I am not sure if it was too much cleanup for a release
> candidate.

No problem, -next is just fine.

Thank you,
Henrik
