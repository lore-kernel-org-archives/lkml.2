Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab2IMWKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:10:55 -0400
Received: from mail.x86-64.org ([217.9.48.20]:37562 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758994Ab2IMWKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:10:50 -0400
Date: Fri, 14 Sep 2012 00:10:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Lin Ming <minggr@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: power: Use KERN_DEBUG when no power resources are
 found
Message-ID: <20120913221047.GA4598@aftab.osrc.amd.com>
References: <1344564353-493-1-git-send-email-aaron.lu@amd.com>
 <20120829020134.GA1761@aaronlu.sh.intel.com>
 <20120913134819.GD19691@aftab.osrc.amd.com>
 <201209132317.32969.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209132317.32969.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:17:32PM +0200, Rafael J. Wysocki wrote:
> I'll take it. There are two more ACPI PM patches that would be good to
> have in v3.6 IMO.

Ok, cool. Can you pls adjust the stable tag to include 3.4 too?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
