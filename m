Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2L1Klk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 05:41:40 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:59698 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2L1Klf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 05:41:35 -0500
X-IronPort-AV: E=Sophos;i="4.84,368,1355097600"; 
   d="scan'208";a="1969310"
Message-ID: <1356691292.2917.9.camel@iceland>
Subject: Re: [Xen-devel] [PATCH 08/14] xen: netback: Remove redundant check
 on unsigned variable
From: Wei Liu <Wei.Liu2@citrix.com>
To: Tushar Behera <tushar.behera@linaro.org>
CC: <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>, <konrad.wilk@oracle.com>
Date: Fri, 28 Dec 2012 10:41:32 +0000
In-Reply-To: <50DD2AFB.6030701@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
	 <1353048646-10935-9-git-send-email-tushar.behera@linaro.org>
	 <1353057394.3499.159.camel@zakaz.uk.xensource.com>
	 <50DD2AFB.6030701@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 05:15 +0000, Tushar Behera wrote:
> On 11/16/2012 02:46 PM, Ian Campbell wrote:
> > On Fri, 2012-11-16 at 06:50 +0000, Tushar Behera wrote:
> >> No need to check whether unsigned variable is less than 0.
> >>
> >> CC: Ian Campbell <ian.campbell@citrix.com>
> >> CC: xen-devel@lists.xensource.com
> >> CC: netdev@vger.kernel.org
> >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > 
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Thanks.
> > 
> 
> This patch was not picked up for 3.8-rc1. Any idea, who should pick this up?

CC'ing Konrad.

