Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946410Ab2JDVd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:33:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37556 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946401Ab2JDVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:33:53 -0400
Date: Thu, 4 Oct 2012 22:33:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20121004213350.GJ13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225201.884628603@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225201.884628603@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 101/180] SCSI: libsas: continue revalidation
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:53:38AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> commit 26f2f199ff150d8876b2641c41e60d1c92d2fb81 upstream.
> 
> Continue running revalidation until no more broadcast devices are
> discovered.  Fixes cases where re-discovery completes too early in a
> domain with multiple expanders with pending re-discovery events.
> Servicing BCNs can get backed up behind error recovery.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> commit 2da74cd8a6bad64d02207396c76d0939f3c57aaa upstream.
[...]

Another 3.0 stable reference.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
