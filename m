Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0LPSLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:11:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:48044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab0LPSLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:11:45 -0500
Message-ID: <4D0A5650.2010004@kernel.org>
Date: Thu, 16 Dec 2010 19:11:28 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Kay Sievers <kay.sievers@vrfy.org>, jeff@garzik.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, jack@suse.cz,
        James.Bottomley@hansenpartnership.com
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
  take#2
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com> <4D0A4196.8040209@kernel.dk> <4D0A4231.2070402@kernel.org> <4D0A4594.6030704@kernel.dk>
In-Reply-To: <4D0A4594.6030704@kernel.dk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 18:11:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 06:00 PM, Jens Axboe wrote:
>> Heh, that was fast.  Anyways, James, it would be great if you can take
>> a look at the sr/sd changes.  I think they're correct but that's kinda
>> expected, so... :-)
> 
> One thing I noticed is that cdrom_check_events() needs an export.

Yeap, indeed.  Thanks for taking care of it.

-- 
tejun
