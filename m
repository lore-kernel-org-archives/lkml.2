Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2CIOyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:54:19 -0500
Received: from twin.jikos.cz ([89.185.236.188]:45916 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab2CIOyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:54:18 -0500
Date: Fri, 9 Mar 2012 15:54:06 +0100
From: David Sterba <dave@jikos.cz>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: dave@jikos.cz, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Message-ID: <20120309145406.GL4334@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Jacek Luczak <difrost.kernel@gmail.com>, dave@jikos.cz,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com> <20120308155211.GF4334@twin.jikos.cz> <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com> <4F595D6D.6080809@cn.fujitsu.com> <20120309105537.GG4334@twin.jikos.cz> <CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com> <20120309114010.GH4334@twin.jikos.cz> <CADDYkjQiMpPHLq4NTe5yo1iZfCgtwTgm+3ZDRUdMACpumsdFqw@mail.gmail.com> <CADDYkjRK3h_e3GPDQMpVwSwn6aQ5MwA1FoF1wFV05=LytK3chg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDYkjRK3h_e3GPDQMpVwSwn6aQ5MwA1FoF1wFV05=LytK3chg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 03:33:24PM +0100, Jacek Luczak wrote:
> > Those two issues go inline. After a longer while of WARN_ON the BUG_ON
> > hit again.
> 
> One more observation. Host is running builds from CI system. After
> BUG_ON pop up all builds take 50% more time to complete.

After a BUG_ON the system is in an inconsistent state and will
misbehave.

> Also I see that current load average stall at value of 7 even if host
> is completely idle.

That's probably because some process is stuck in a D-state after the
crash.


david
