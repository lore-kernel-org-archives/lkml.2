Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1BGSNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:13:04 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:34582 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab1BGSND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:13:03 -0500
Date: Mon, 7 Feb 2011 12:45:52 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Matt <jackdachef@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Message-ID: <20110207174552.GC3457@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Matt <jackdachef@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
> 
> So that means that the file-corruption which existed until 2.6.37-rc6
> and got triggered (for me) more easily via "dm crypt: scale to
> multiple CPUs"
> is fixed now ?

Well, a patch exists for it that will be merged into 2.6.38.

> That should give ext4 a nice speedup for >=2.6.38 :)

I'm not going to make it be the default for 2.6.38, since it's fairly
late in the -rc features.  People who want it can explicitly enable it
using the mount option mblk_io_submit, though.  (And let me know your
success stories!  :-) I will be enabling it as the default in
2.6.39-rc1.

> Reported-by: Matthias Bayer <jackdachef <at> gmail <dot> com >

Sure!

						- Ted
