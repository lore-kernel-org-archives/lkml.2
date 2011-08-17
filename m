Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1HQOem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:34:42 -0400
Received: from shawmail.shawcable.com ([64.59.128.220]:9643 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1HQOek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:34:40 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=v9IqiuXHtmwFiI2YJqo6dQmw2SJvdDx3gP8sCAnt4Ec= c=1 sm=1
 a=BN9VpAPFCYkA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=V1M8Njz4AAAA:8 a=eGyJrCGKOI9XGV8uAVgA:9
 a=CjuIK1q_8ugA:10 a=oJtbXUxe65UA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
X-IronPort-AV: E=Sophos;i="4.68,240,1312178400"; 
   d="scan'208";a="444638873"
X-reinject: true
References: <4E4BC296.1040004@mageia.org>
In-Reply-To: <4E4BC296.1040004@mageia.org>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <96850198-2253-40F7-B99C-62A6097278FA@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
X-Mailer: iPhone Mail (8L1)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds
Date: Wed, 17 Aug 2011 08:35:14 -0600
To: Thomas Backlund <tmb@mageia.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-17, at 7:31 AM, Thomas Backlund <tmb@mageia.org> wrote:
> 
> One of our buildnodes, a 8-core Supermicro X7DA8 system,
> and a WDC WD1002FAEX-0 sata disk hits the "blocked for more than 120 seconds" several times, and ends up resetting the ata bus.
> 
> The disk does not report any errors with smart, and we have the same model in a 24-core Supermicro X8DTN, and it does not show this problem.
> 
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> ata3.00: failed command: FLUSH CACHE EXT
> ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>         res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata3.00: status: { DRDY }
> ata3: soft resetting link
> ata3.00: configured for UDMA/133
> ata3.00: retrying FLUSH 0xea Emask 0x4
> ata3: EH complete

This is a problem with your disk hardware. 

Cheers, Andreas