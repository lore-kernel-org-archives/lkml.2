Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2CILk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:40:27 -0500
Received: from twin.jikos.cz ([89.185.236.188]:41571 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2CILk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:40:26 -0500
Date: Fri, 9 Mar 2012 12:40:10 +0100
From: David Sterba <dave@jikos.cz>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: dave@jikos.cz, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Message-ID: <20120309114010.GH4334@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Jacek Luczak <difrost.kernel@gmail.com>, dave@jikos.cz,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com> <20120308155211.GF4334@twin.jikos.cz> <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com> <4F595D6D.6080809@cn.fujitsu.com> <20120309105537.GG4334@twin.jikos.cz> <CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 12:08:12PM +0100, Jacek Luczak wrote:
> For this one I've created also a report [1].
> >
> > so there is probably other problem in reservations and it just blew up during
> > the unlink call.
> 
> Could be as this came up after a longer time of throwing above WARN_ON.
> 
> I'm now cloning the Linus tree. Lets see if both will pop up on there.

The 3.3-rc6 should help in one case, with

http://thread.gmane.org/gmane.comp.file-systems.btrfs/15268

but I was able to reproduce the WARN_ON even with this patch, didn't get
to debugging it again yet.


david
