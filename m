Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2DWTWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:22:06 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:30038 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2DWTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:22:04 -0400
Date: Mon, 23 Apr 2012 21:22:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [GIT] modpost fix for newer toolchain
Message-ID: <20120423192201.GA18512@merkur.ravnborg.org>
References: <20120423184918.GA27862@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423184918.GA27862@sepie.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 08:49:18PM +0200, Michal Marek wrote:
> Hi Linus,
> 
> Please pull this modpost patch. It fixes build failure with newer gcc that adds
> some internal symbols that end in "__mod_*_device_table", but are not
> actually the tables themselves.
> 
> Michal
> 
> The following changes since commit 0eb043d0eec44cd083ea6910b1db2f77eb212ebd:
> 
>   Subject: [PATCH] tags.sh: Add missing quotes (2012-04-02 11:28:17 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes
> 
> for you to fetch changes up to e88aa7bbbe3046a125ea1936b16bb921cc9c6349:
> 
>   Fix modpost failures in fedora 17 (2012-04-18 21:42:07 +0200)

Hi Michal.

The patch missed a "Cc: stable..." as discussed in the thread about
said patch.

	Sam
