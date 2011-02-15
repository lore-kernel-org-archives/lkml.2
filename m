Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1BOBLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:11:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab1BOBLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:11:06 -0500
Date: Mon, 14 Feb 2011 20:11:03 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: Bret Towe <magnade@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/nfsd/nfs4state.c
Message-ID: <20110215011102.GA14825@pad.home.fieldses.org>
References: <AANLkTinW7mWsrgwY2JsG9U-Qk1icKyApbdVJvavw4iGZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinW7mWsrgwY2JsG9U-Qk1icKyApbdVJvavw4iGZ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 02:12:06PM -0800, Bret Towe wrote:
> got this bug shortly after a fresh boot into 2.6.38-rc4 a nfs client
> at the time was logging into its nfs home
> the server is a 32bit setup running debian squeeze
> the client at the time was 64bit debian squeeze (also running 2.6.38-rc4)
> and the output below is from the server
> 
> let me know if you need more info and I can do tests if required

This is a known bug.  It should be fixed in

	git://linux-nfs.org/~bfields/linux.git for-2.6.38

--b.
