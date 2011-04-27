Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab1D0Sx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:53:29 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:24585 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1D0Sx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:53:28 -0400
Subject: Re: [PATCHv2 1/4] ethtool: cosmetics: enforce const-ness in
 ethtool_cmd_speed
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1303929290-21037-2-git-send-email-decot@google.com>
References: <1303001651-4074-1-git-send-email-decot@google.com>
	 <1303929290-21037-2-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 27 Apr 2011 19:41:03 +0100
Message-ID: <1303929663.2875.97.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Apr 2011 18:41:07.0002 (UTC) FILETIME=[AB61B1A0:01CC050A]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18098.005
X-TM-AS-Result: No--8.454500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 11:34 -0700, David Decotigny wrote:
> The 'ep' argument of ethtool_cmd_speed is not altered: advertise it in
> protoype. +Indentation fix. Also add comments to advise using the
> ethtool_cmd_speed API to get/set the link speed.
> 
> Signed-off-by: David Decotigny <decot@google.com>
Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

