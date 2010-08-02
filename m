Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0HBHS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:18:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:35250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0HBHS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:18:57 -0400
Message-ID: <4C567137.9060407@kernel.org>
Date: Mon, 02 Aug 2010 09:18:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Saeed Bishara <saeed@marvell.com>, Mark Lord <liml@rtr.ca>,
        Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 1/2 #upstream] sata_fsl,mv,nv: prepare for NCQ command
 completion update
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C247B54.2050900@garzik.org> <4C247C36.6040007@kernel.org> <4C24A903.4060908@kernel.org> <4C5607AF.8020109@garzik.org>
In-Reply-To: <4C5607AF.8020109@garzik.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:18:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

On 08/02/2010 01:47 AM, Jeff Garzik wrote:
>> So, something like this.  I tested both flavors of sata_nv but don't
>> have access to sata_mv or sata_fsl, but the conversion is pretty
>> straight forward and failures should be pretty easy to catch.
> 
> applied

Are you planning on applying the second patch too?

Thanks.

-- 
tejun
