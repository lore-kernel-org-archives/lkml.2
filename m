Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1BIJnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:43:31 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:57903 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1BIJna convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Wed, 9 Feb 2011 04:43:30 -0500
Message-Id: <4D526FF40200007800030FEF@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 09 Feb 2011 09:44:04 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jiri Slaby" <jslaby@suse.cz>
Cc: "Tim Deegan" <Tim.Deegan@citrix.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>, <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix jiffy calculations in calibrate_delay_direct
	 to handle overflow
References: <4D525EF00200007800030F0F@vpn.id2.novell.com>
 <4D525CA8.60604@suse.cz>
In-Reply-To: <4D525CA8.60604@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.02.11 at 10:21, Jiri Slaby <jslaby@suse.cz> wrote:
> On 02/09/2011 09:31 AM, Jan Beulich wrote:
>> Fixes a hang when booting as dom0 under Xen, when jiffies can be
>> quite large by the time the kernel init gets this far.
> 
> As I wrote this might happen if the boot till this point takes ~ 5
> minutes because we start at -5 minutes.
> 
> That said, is this a candidate for stable? (If so, please CC stable.)

Honestly, I'm not certain (given that mainline Xen Dom0 support
is still only in its beginnings).

Jan

