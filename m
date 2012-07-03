Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2GCNVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:21:03 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:49047 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab2GCNU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:20:59 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJjS0PG5UX
X-RZG-CLASS-ID: mo00
Date: Tue, 3 Jul 2012 15:20:49 +0200
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, apw@canonical.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/13] drivers: hv: kvp
Message-ID: <20120703132049.GA10663@aepfle.de>
References: <20120621224737.GA5933@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155EC47A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120622132547.GA2639@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED14D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626213954.GA4840@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED64A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626222205.GA5948@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120628142340.GA21537@aepfle.de>
 <426367E2313C2449837CD2DE46E7EAF9155EF399@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9155EF399@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, KY Srinivasan wrote:

> While I toyed with your proposal, I feel it just pushes the problem
> out of the daemon code - we would still need to write distro specific
> scripts. If this approach is something that everybody is comfortable
> with, I can take a stab at implementing that. 

Until NetworkManager is feature complete and until every distro is using
NetworkManager per default the kvp_daemon needs distro specific code to
get and set network related settings.
Doing it with an external script will simplify debugging and changes to
the code.

Olaf
