Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1AMAPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:15:23 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:62295 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460Ab1AMAPV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:15:21 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 19:15:20 EST
X-AuditID: 1209190c-b7ba9ae0000009f8-a1-4d2e42eb8e89
Subject: Re: Power plug off / on - EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTinC=i24FaOtB3srbCUROza1V2TQ0zxNMq+QH+mj@mail.gmail.com>
Date: Wed, 12 Jan 2011 19:09:51 -0500
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B48664E0-16B7-49A5-AE50-1C3DA751DC2C@mit.edu>
References: <AANLkTinC=i24FaOtB3srbCUROza1V2TQ0zxNMq+QH+mj@mail.gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAARcg5EE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 12, 2011, at 4:35 PM, Luis R. Rodriguez wrote:

> When I yank my power chord off of my Thinkpad T61 running 2.6.37 I get
> the following:
> 
> [   79.523778] Monitor-Mwait will be used to enter C-3 state
> [   81.195402] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
> 
> mcgrof@tux ~ $ mount| grep sda1
> /dev/sda1 on / type ext4 (rw,errors=remount-ro,commit=600)

Sounds like you have some userspace script which is being triggered on the transition running on batteries, and it's doing a remount -o commit=600 to save power.   Are you using laptop_mode by any chance?

-- Ted

