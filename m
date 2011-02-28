Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1B1KNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:13:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:57501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab1B1KM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:12:59 -0500
Date: Mon, 28 Feb 2011 11:12:57 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        torvalds@linux-foundation.org, ebiederm@xmission.com
Subject: Re: Another list corruption in networking stack with
 2.6.38-rc6-00020-gd8204a3?
Message-ID: <20110228101257.GA30740@tiehlicka.suse.cz>
References: <20110226082149.GA9623@tiehlicka.suse.cz>
 <20110226.002523.39185761.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110226.002523.39185761.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 26-02-11 00:25:23, David Miller wrote:
> From: Michal Hocko <mhocko@suse.cz>
> Date: Sat, 26 Feb 2011 09:21:49 +0100
> 
> > I am currently on 2.6.38-rc6-00020-gd8204a3 which already contains some
> > list_del fixes but I remember that there were still some of them
> > pending. I can really see at least 5f04d5068 which I do not have. Is it
> > possible that it fixes the above corruption? 
> 
> That commit absolutely will fix your bug.

You are right. It survived my over weekend testing so it should be ok.
Thanks!

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
