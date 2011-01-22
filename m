Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab1AVQJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 11:09:41 -0500
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:40278 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1AVQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 11:09:40 -0500
Date: Sat, 22 Jan 2011 11:09:38 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NILFS crash on 2.6.37
Message-ID: <20110122160938.GA23181@animx.eu.org>
Mail-Followup-To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110121.163738.135792151.ryusuke@osrg.net> <20110121.181859.144825828.ryusuke@osrg.net> <20110122015748.GA3174@animx.eu.org> <20110122.230956.176521815.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110122.230956.176521815.ryusuke@osrg.net>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryusuke Konishi wrote:
> On Fri, 21 Jan 2011 20:57:48 -0500, Wakko Warner wrote:
> > That patch fix it.  Just a note, the 2.6.37 vanilla source was about 20
> > lines up from 704
> 
> Thanks for testing.  Will send upstream and to stable.

No problem.

> > > > > [ 1202.581501] NILFS warning: broken superblock. using spare superblock.
> > > > > [ 1202.582093] NILFS warning: broken superblock. using spare superblock.
> > 
> > Why does it say this 2 times?  Just curious.
> 
> Because each super block is read twice in different block sizes.
> 
> Well, indeed it looks confusing.  I'll try to do something.

Ah, I see.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
