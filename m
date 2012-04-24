Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2DXRo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:44:56 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:26541 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756783Ab2DXRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:44:55 -0400
Message-ID: <1335289485.17274.46.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH net-next 1/3] Add capability to retrieve plug-in module
 EEPROM
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
CC: <smhodgson@solarflare.com>, <netdev@vger.kernel.org>,
        <bruce.w.allan@intel.com>, <decot@google.com>,
        <alexander.h.duyck@intel.com>, <linux-kernel@vger.kernel.org>
Date: Tue, 24 Apr 2012 18:44:45 +0100
In-Reply-To: <20120423.172848.1733968863825393980.davem@davemloft.net>
References: <4F9031BF.10106@solarflare.com>
	 <20120423.172848.1733968863825393980.davem@davemloft.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18862.005
X-TM-AS-Result: No--10.861300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 17:28 -0400, David Miller wrote:
> You can't just submit three seperate patches each with the same exact
> Subject line.
> 
> Otherwise someone scanning the commit headers can't figure out what
> is different in each of these changes.
> 
> There also is no signoff from Ben for patches #2 or #3, did he review
> them?  If so, why didn't he ACK or sign off on it?  If not, why not?

Sorry, I've been busy with another project.  I'll reply to Stuart's
patches faster next round.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

