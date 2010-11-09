Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0KIQyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:54:02 -0500
Received: from imr4.ericy.com ([198.24.6.8]:40813 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0KIQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:53:59 -0500
Date: Tue, 9 Nov 2010 08:53:14 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [26/32] drivers/hwmon/via-cputemp.c: Use pr_fmt and pr_<level>
Message-ID: <20101109165314.GA17165@ericsson.com>
References: <bd2bd159db94be1cfdb2bc176d3a5bb2705f79ef.1287556801.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bd2bd159db94be1cfdb2bc176d3a5bb2705f79ef.1287556801.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 06:51:50AM -0000, Joe Perches wrote:
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
