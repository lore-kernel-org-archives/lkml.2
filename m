Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1IFWnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:43:06 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:53397 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1IFWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:42:57 -0400
Date: Tue, 6 Sep 2011 23:42:52 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: FUSE kmemleak report
Message-ID: <20110906224252.GA20218@sucs.org>
References: <20110905223734.GB26980@sucs.org>
 <CAHkRjk4QXbzzS6_Ks8W_QF14ijQdrXUEN82ifnm8ecxenqYiKA@mail.gmail.com>
 <874o0pkiao.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874o0pkiao.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 01:43:27PM +0200, Miklos Szeredi wrote:
> 
> Sitsofe, thanks for the report.
> 
> Could you please try the patch below?

You're welcome. The patch resolves the leak for me on 3.1.0-rc5 on
Ubuntu 10.04 using GNOME 2.30.2 (I could previously reproduce it my
logging in as one user, logging out, logging in as another user and then
as root doing echo scan > /sys/kernel/debug/kmemleak ).

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

-- 
Sitsofe | http://sucs.org/~sits/
