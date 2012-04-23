Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2DWFM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:12:29 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:17104 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2DWFM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:12:28 -0400
Date: Mon, 23 Apr 2012 07:12:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, tj@kernel.org, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120423051227.GB6709@merkur.ravnborg.org>
References: <20120420194309.GA3689@merkur.ravnborg.org> <20120422.152210.1520263792125579554.davem@davemloft.net> <20120422200554.GA6385@merkur.ravnborg.org> <20120422.220054.1961736352806510855.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120422.220054.1961736352806510855.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 10:00:54PM -0400, David Miller wrote:
> 
> So here is a sparc64 conversion to NO_BOOTMEM.
Great!

I looked briefly through the patch - no comments.
I will take a more carefull look tonight.

	Sam
