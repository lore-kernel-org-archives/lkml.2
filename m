Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab1IPSTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:19:11 -0400
Received: from eazy.amigager.de ([213.239.192.238]:35911 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1IPSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:19:10 -0400
Date: Fri, 16 Sep 2011 20:19:22 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: echo 3 > /proc/.../drop_caches goes mad with 3.1-rc6, maybe
 fsnotify related
Message-ID: <20110916181922.GA7993@mac.home>
Mail-Followup-To: Hugh Dickins <hughd@google.com>,
	Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org
References: <20110915200514.GA30223@mac.home>
 <alpine.LSU.2.00.1109151432330.10523@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1109151432330.10523@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 14:42:05 -0700, Hugh Dickins wrote:

[...]

> Although these stacktraces don't implicate find_get_pages() at all,
> please try Shaohua's fix below (see thread: [BUG] infinite loop in
> find_get_pages()), which Linus put in his tree yesterday.

Hi,

thanks, I upgraded to git master
c455ea4f122d21c91fcf4c36c3f0c08535ba3ce8 and the problem is gone.

Regards,
Tino

