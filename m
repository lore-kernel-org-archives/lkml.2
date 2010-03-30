Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0C3ATg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 20:19:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:34318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0C3ATe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 20:19:34 -0400
Message-ID: <4BB14377.5040607@kernel.org>
Date: Tue, 30 Mar 2010 09:19:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] libata: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org> <1269885165-18617-16-git-send-email-tj@kernel.org> <4BB10A21.9080602@pobox.com>
In-Reply-To: <4BB10A21.9080602@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Mar 2010 00:19:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 05:14 AM, Jeff Garzik wrote:
> On 03/29/2010 01:52 PM, Tejun Heo wrote:
>> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>> gfp.h or slab.h is included as necessary.
> 
> Unless you object, I'll go ahead and apply this to #upstream...

Yes, please.

Thank you.

-- 
tejun
