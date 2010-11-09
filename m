Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0KIQ6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:58:33 -0500
Received: from imr4.ericy.com ([198.24.6.8]:39085 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0KIQ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:58:32 -0500
Date: Tue, 9 Nov 2010 08:57:43 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, Juerg Haefliger <juergh@gmail.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [28/32] drivers/hwmon/vt1211.c: Use pr_fmt and pr_<level>
Message-ID: <20101109165743.GA17453@ericsson.com>
References: <d95988253a87f5d8367607266ab92792f90ffd34.1287556801.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d95988253a87f5d8367607266ab92792f90ffd34.1287556801.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 06:51:52AM -0000, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 

Applied, with a minor change. checkpatch.pl complains about line lengths
around lines 1336 and 1342. I used the original split instead of the one-line
text.

Thanks,
Guenter
