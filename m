Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1JHVWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 17:22:17 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46447 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1JHVWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 17:22:15 -0400
Date: Sat, 8 Oct 2011 17:22:14 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Nikitas Angelinas <nikitasangelinas@gmail.com>
Cc: adilger.kernel@dilger.ca, adilger@whamcloud.com, johann@whamcloud.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikitas_angelinas@xyratex.com, andrew_perepechko@xyratex.com
Subject: Re: [PATCH 1/2] ext4: MMP: kmmpd should use nodename from
 init_uts_ns.name, not sysname
Message-ID: <20111008212214.GN7948@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Nikitas Angelinas <nikitasangelinas@gmail.com>,
	adilger.kernel@dilger.ca, adilger@whamcloud.com,
	johann@whamcloud.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, nikitas_angelinas@xyratex.com,
	andrew_perepechko@xyratex.com
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com>
 <1317339500-4341-1-git-send-email-nikitas_angelinas@xyratex.com>
 <1317339500-4341-2-git-send-email-nikitas_angelinas@xyratex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317339500-4341-2-git-send-email-nikitas_angelinas@xyratex.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 12:38:19AM +0100, Nikitas Angelinas wrote:
> sysname holds "Linux" by default, i.e. what appears when doing a "uname
> -s"; nodename should be used to print the machine's hostname, i.e. what
> is returned when doing a "uname -n" or "hostname", and what
> gethostname(2)/sethostname(2) manipulate, in order to notify the
> administrator of the node which is contending to mount the filesystem.
> 
> Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
> Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
> Acked-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
