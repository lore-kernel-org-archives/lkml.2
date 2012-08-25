Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2HYRsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:48:10 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:47050 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2HYRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:48:07 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkxYAEwPOVBV5qoUPGdsb2JhbABFhRoiAYUAsC0ZAQEBAR4ZDSeCIAEBBTocEwEPEAgDDgcDLhQlChoTiBG7VxSKdIYxYAOVVIVsjQ8
X-IronPort-AV: E=Sophos;i="4.77,826,1336341600"; 
   d="scan'208";a="399798605"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 25 Aug 2012 19:53:16 +0200
To: Bernhard Froemel <bfroemel@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: Re: [PATCH v2 1/2] apple-gmux: Fix index read functions
Message-ID: <20120825175316.GA4292@polaris.bitmath.org>
References: <50388C45.6030707@gmail.com>
 <1345883449-2790-1-git-send-email-bfroemel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345883449-2790-1-git-send-email-bfroemel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 10:30:48AM +0200, Bernhard Froemel wrote:
> From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
> 
> Study of Apple's binary driver revealed that the GMUX_READ_PORT should
> be written between calls to gmux_index_wait_ready and
> gmux_index_wait_complete (i.e., the new index protocol must be
> followed). If this is not done correctly, the indexed
> gmux device only partially accepts writes which lead to problems
> concerning GPU switching. Special thanks to Seth Forshee who helped
> greatly with identifying unnecessary changes.
> 
> Signed-off-by: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
> ---

Hi Bernhard,

thanks for your patch, this works splendidly; I can resume and select
different screen resolutions using xrandr.

    Tested-by: Henrik Rydberg <rydberg@euromail.se>

Henrik
