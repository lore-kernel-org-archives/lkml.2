Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2GZMhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:37:05 -0400
Received: from osrc3.amd.com ([217.9.48.20]:41042 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab2GZMhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:37:01 -0400
Date: Thu, 26 Jul 2012 14:36:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 12/13] driver core: firmware loader: use small
 timeout for cache device firmware
Message-ID: <20120726123655.GE30717@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-13-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343149213-10160-13-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:12AM +0800, Ming Lei wrote:
> Because device_cache_firmwares only cache the firmware which has been
> loaded sucessfully at leat once, using a small loading timeout should

			least

> be OK.

Your commit message doesn't explain why exactly we decrease the timeout:
you should probably say that this patch overrides the default 60s
timeout because we're in pre-suspend/-hibernate mode where we have
userspace and are able to load the firmware quickly.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
