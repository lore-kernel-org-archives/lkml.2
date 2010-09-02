Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0IBIYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:24:46 -0400
Received: from csamuel.org ([74.50.50.137]:43581 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0IBIYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:24:45 -0400
Message-ID: <4C7F5F38.3050104@csamuel.org>
Date: Thu, 02 Sep 2010 18:24:24 +1000
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: "chxanders@gmail.com" <chxanders@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, miaox@cn.fujitsu.com,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and functions
References: <4C7E2CA9.9060702@cn.fujitsu.com> <1283354736.2059.1206.camel@laptop> <4C7F39B3.4000901@cn.fujitsu.com> <1283414119.2059.1785.camel@laptop> <1283414220.2059.1789.camel@laptop> <AANLkTinT3X+7hA9UvS8nKqpVzz1u1e-7UZNbfL_1UeX8@mail.gmail.com>
In-Reply-To: <AANLkTinT3X+7hA9UvS8nKqpVzz1u1e-7UZNbfL_1UeX8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/10 18:16, chxanders@gmail.com wrote:

> Umm, isn't the only one that can do that the copyright holder?

The copyright holder can use whatever license they wish; the LGPL
tells the licensee what rights *they* have, which includes distributing
the software under the (more strict) GPLv2.

cheers,
Chris (not a lawyer either, thankfully!)
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
