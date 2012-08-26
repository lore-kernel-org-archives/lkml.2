Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2HZAsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 20:48:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50188 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2HZAsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 20:48:05 -0400
Date: Sat, 25 Aug 2012 19:47:59 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Bernhard Froemel <bfroemel@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: Re: [PATCH v2 1/2] apple-gmux: Fix index read functions
Message-ID: <20120826004759.GB20735@ubuntu-mba51>
Mail-Followup-To: Bernhard Froemel <bfroemel@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bernhard Froemel <froemel@vmars.tuwien.ac.at>
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

This does better match what Apple's driver does. Thanks Bernhard.

Acked-by: Seth Forshee <seth.forshee@canonical.com>

