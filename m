Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1HQVSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:18:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab1HQVSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:18:22 -0400
Date: Wed, 17 Aug 2011 14:17:50 -0700
From: Greg KH <gregkh@suse.de>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Marc Dietrich <marvin24@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
        Vitaliy Ivanov <vitalivanov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: nvec: Fixed various style issues.
Message-ID: <20110817211750.GA4044@suse.de>
References: <1313613397-18126-1-git-send-email-me@akshayjoshi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313613397-18126-1-git-send-email-me@akshayjoshi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 04:36:32PM -0400, Akshay Joshi wrote:
> Removed trailing spaces, brace/parenthesis issues and other coding style
> problems, along with commented out code.

Please break this into individual patches, one per logical change, so we
can properly review it and apply it easier.

thanks,

greg k-h
