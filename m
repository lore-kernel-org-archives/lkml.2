Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1D1CDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:03:09 -0400
Received: from mail.solarflare.com ([216.237.3.220]:5397 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1D1CDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:03:07 -0400
Subject: Re: [PATCHv3 1/7] ethtool: cosmetics: enforce const-ness in
 ethtool_cmd_speed
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1303954043-17440-2-git-send-email-decot@google.com>
References: <1303954043-17440-1-git-send-email-decot@google.com>
	 <1303954043-17440-2-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 28 Apr 2011 03:03:02 +0100
Message-ID: <1303956182.3032.422.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2011 02:03:06.0562 (UTC) FILETIME=[6A456A20:01CC0548]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18098.005
X-TM-AS-Result: No--8.454500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 18:27 -0700, David Decotigny wrote:
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

