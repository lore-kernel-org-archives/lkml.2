Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab1FAPqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:46:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51650 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1FAPqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:46:47 -0400
Message-ID: <4DE65EDF.9020001@zytor.com>
Date: Wed, 01 Jun 2011 08:46:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
References: <4DE3E9E7.8020008@zytor.com> <20110531195201.GB7995@1wt.eu> <201106010943.11180.tvrtko.ursulin@onelan.co.uk>
In-Reply-To: <201106010943.11180.tvrtko.ursulin@onelan.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 01:43 AM, Tvrtko Ursulin wrote:
> 
> I use them to go from one stable version to the next and it is quite 
> convenient. Maybe there is another way to achieve that (that "all" in "git and 
> all")?
> 

You can pull down the stable git tree and do diffs to your heart's
content, obviously.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

