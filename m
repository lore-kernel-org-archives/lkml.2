Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2DCRZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:25:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab2DCRY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:24:58 -0400
Date: Tue, 3 Apr 2012 19:24:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Dave Jones <davej@redhat.com>, David Sterba <dsterba@suse.cz>,
        Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120403172456.GE14083@ds.suse.cz>
Reply-To: dsterba@suse.cz
References: <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
 <20120403142607.GA14083@ds.suse.cz>
 <20120403162023.GA7227@redhat.com>
 <20120403163343.GD14083@ds.suse.cz>
 <20120403165055.GA10975@redhat.com>
 <20120403170750.GB10975@redhat.com>
 <20120403171632.GA25334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403171632.GA25334@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 01:16:33PM -0400, Dave Jones wrote:
> Yep that fixes it.  Chris I'll mail it to you again with a proper sign-off.

Thanks! Tested here as well.


david
