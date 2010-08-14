Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0HNIc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:32:26 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:39556 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932739Ab0HNIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:32:25 -0400
Date: Sat, 14 Aug 2010 10:32:12 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andreas Bombe <aeb@debian.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging/comedi das08_cs.c: Fix io_req_t conversion
Message-ID: <20100814083212.GB11915@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andreas Bombe <aeb@debian.org>, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
References: <1281749062-9907-1-git-send-email-aeb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281749062-9907-1-git-send-email-aeb@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Andreas.

Greg, do you have other -staging stuff pending to push to Linus? If so,
could you take it? Otherwise, I'll queue it up for my bugfixes branch.

On Sat, Aug 14, 2010 at 03:24:22AM +0200, Andreas Bombe wrote:
> Commit 90abdc3b9 converted all PCMCIA users away from io_req_t. In
> das08_cs.c the converted IO lines mask setting was added but the old
> line using the now inexistent p_dev->io was not removed.
> 
> Signed-off-by: Andreas Bombe <aeb@debian.org>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

Best,
	Dominik
