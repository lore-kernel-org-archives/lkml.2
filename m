Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1GUCmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 22:42:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40419 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1GUCmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 22:42:09 -0400
Date: Thu, 21 Jul 2011 04:42:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [BUGFIX] ACPI, APEI, EINJ Param support is disabled by default
Message-ID: <20110721024204.GJ8006@one.firstfloor.org>
References: <1311149369-20624-1-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311149369-20624-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +static bool param_extension;
> +module_param(param_extension, bool, 0);

Make it 0644, then it can be changed at runtime. No need to require a reboot.

-Andi
