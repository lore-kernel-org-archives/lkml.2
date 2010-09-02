Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0IBHHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 03:07:47 -0400
Received: from csamuel.org ([74.50.50.137]:48239 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0IBHHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 03:07:45 -0400
Message-ID: <4C7F4D2C.8000206@csamuel.org>
Date: Thu, 02 Sep 2010 17:07:24 +1000
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and functions
References: <4C7E2CA9.9060702@cn.fujitsu.com> <1283354736.2059.1206.camel@laptop> <4C7F39B3.4000901@cn.fujitsu.com> <4C7F3C60.7000205@csamuel.org> <4C7F4938.6090202@cn.fujitsu.com>
In-Reply-To: <4C7F4938.6090202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/10 16:50, Miao Xie wrote:

> I just change the "2.1" to "2" in your patch, because the
> orignal code is LGPL v2.1, LGPL v2.1 permits us to apply
> the terms of the ordinary GNU General Public License instead
> of it.

Ahhh excellent, I hadn't realised that was possible; well spotted!

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
