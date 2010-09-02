Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0IBHNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 03:13:13 -0400
Received: from csamuel.org ([74.50.50.137]:52487 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0IBHNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 03:13:12 -0400
Message-ID: <4C7F4E73.3040500@csamuel.org>
Date: Thu, 02 Sep 2010 17:12:51 +1000
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Miao Xie <miaox@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] improve the performance of some memory copy functions
References: <4C7F3A26.6020607@cn.fujitsu.com> <20100902065347.GA29972@elte.hu>
In-Reply-To: <20100902065347.GA29972@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/10 16:53, Ingo Molnar wrote:

> and if glibc is under the GPL v2.1

It's LGPL v2.1 which can be converted to GPL v2 under section 3
of its license. See: http://www.gnu.org/licenses/lgpl-2.1.html

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
