Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0LPSFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:05:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:51796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab0LPSFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:05:12 -0500
Message-ID: <4D0A54AD.90400@kernel.org>
Date: Thu, 16 Dec 2010 19:04:29 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <20101216170030.GA13585@infradead.org>
In-Reply-To: <20101216170030.GA13585@infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 18:04:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Christoph.

On 12/16/2010 06:00 PM, Christoph Hellwig wrote:
> Any chance could could conver all block drivers to the new methods
> instead of leaving us with yet another incomplete transition?

Yeah, sure.  I wanted to make sure the approach is agreed on before
going forward with the rest of changes.  It's not like we have a lot
of .media_changed in the kernel anyway.  The only problem is that some
drivers are quite obscure at this point and would be pretty difficult
to verify, but then again if nobody can noticie the breakage, maybe
it's not broken at all.  Once things settle down, I'll go ahead with
the rest of the conversion.

Thanks.

-- 
tejun
