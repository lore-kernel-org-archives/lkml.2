Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0LPQcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:32:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:43495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab0LPQb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:31:57 -0500
Message-ID: <4D0A3EE1.4050404@kernel.org>
Date: Thu, 16 Dec 2010 17:31:29 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
In-Reply-To: <1291838262-21274-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 16:31:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 08:57 PM, Tejun Heo wrote:
> This is the second take of in-kernel-disk-event patchset which
> implements in-kernel disk event handling framework and adds support
> for it to sr and sd.  This is largely to move media presence polling
> into kernel as userspace implementation turned out to be quite
> problematic over the years.

Kay, Jens, James, how does this look to you guys?

Thanks.

-- 
tejun
