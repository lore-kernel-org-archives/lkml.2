Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2GILuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:50:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2GILuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:50:21 -0400
Subject: Re: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
From: Jean Delvare <jdelvare@suse.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1341820572.4605.35.camel@amber.site>
References: <1341583705.4655.18.camel@amber.site>
	 <4FF71F1C.4040608@xenotime.net> <1341597439.4655.23.camel@amber.site>
	 <4FF72733.8000007@linux.intel.com>
	 <1341605949.22584.6.camel@x61.thuisdomein>
	 <1341820572.4605.35.camel@amber.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 09 Jul 2012 13:50:05 +0200
Message-ID: <1341834605.4605.53.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 09 juillet 2012 à 09:56 +0200, Jean Delvare a écrit :
> As for options still depending on EXPERIMENTAL when they no longer
> should, this can partly be explained when the EXPERIMENTAL dependency
> doesn't show up in the short description. This is the case of
> CONFIG_CC_STACKPROTECTOR. As everybody has CONFIG_EXPERIMENTAL enabled,
> nobody notices the dependency.

Sorry, I got it the wrong way around (not that it necessarily matters
for the general picture): CONFIG_CC_STACKPROTECTOR no longer depends on
CONFIG_EXPERIMENTAL, but it does still have "(EXPERIMENTAL)" in its
short description. So there is no excuse for us not noticing, assuming
the feature is really no longer experimental.

-- 
Jean Delvare
Suse L3

