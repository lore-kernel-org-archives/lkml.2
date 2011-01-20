Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1ATQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:12:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab1ATQMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:12:35 -0500
Date: Thu, 20 Jan 2011 11:08:49 -0500
From: Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [2.6.38-rc1] btrfs potential false-positive lockdep report...
Message-ID: <20110120160849.GA6609@dhcp231-156.rdu.redhat.com>
References: <AANLkTinTkAtUkZApi-EMpTx-R7sBagLnd4uYnUTL5Lek@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinTkAtUkZApi-EMpTx-R7sBagLnd4uYnUTL5Lek@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 10:53:51AM +0700, Daniel J Blueman wrote:
> I saw a lockdep report with an instrumented 2.6.38-rc1 kernel [1].
> 
> Checking the code, it looks more likely a false-positive due to the
> lock manipulation to satisfy lockdep, since CONFIG_DEBUG_LOCK_ALLOC is
> defined.
> 
> Is this the case?
> 

Yeah these pop up every once and a while, its safe to just ignore it.  Thanks,

Josef
