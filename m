Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab0KIQjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:39:54 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37471 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0KIQju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:39:50 -0500
Date: Tue, 9 Nov 2010 08:39:08 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, Juerg Haefliger <juergh@gmail.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [08/32] drivers/hwmon/dme1737.c: Use pr_fmt and pr_<level>
Message-ID: <20101109163908.GA15024@ericsson.com>
References: <cd6d2bea37cda67b4a06436e011fedf32351352b.1287556801.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cd6d2bea37cda67b4a06436e011fedf32351352b.1287556801.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 06:51:32AM -0000, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
Applied.

Thanks,
Guenter
