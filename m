Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2BTUv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:51:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41002 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2BTUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:51:25 -0500
Date: Mon, 20 Feb 2012 12:51:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/3] ahci: add AHCI_HFLAG_STRICT_SPEC host flag
Message-ID: <20120220205115.GA3538@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1329768563-13715-1-git-send-email-computersforpeace@gmail.com>
 <1329768563-13715-2-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329768563-13715-2-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Overall the patchset looks good but

On Mon, Feb 20, 2012 at 12:09:21PM -0800, Brian Norris wrote:
> +	AHCI_HFLAG_STRICT_SPEC		= (1 << 15), /* strict AHCI spec */

can you please use something more specific?  e.g. something like
SKIP_ENGINE_ON_PORT_START and then explain what the flag is about in
the comment?

Thanks.

-- 
tejun
