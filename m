Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1LSMkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:40:41 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:42421 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1LSMki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:40:38 -0500
Message-ID: <4EEF30C2.4040803@nod.at>
Date: Mon, 19 Dec 2011 13:40:34 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
References: <1321572864-23628-1-git-send-email-richard@nod.at>  <4EEDFC16.90303@nod.at> <1324219540.3091.28.camel@dabdike.int.hansenpartnership.com> <4EEDFE4E.6090104@nod.at> <4EEF2714.1080402@suse.de>
In-Reply-To: <4EEF2714.1080402@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes,

On 19.12.2011 12:59, Hannes Reinecke wrote:
> Nack.
>
> This patch is wrong.
>
> scsi_dh_attach() (and, incidentally, scsi_dh_set_params()) should
> return a standard error value. SCSI_DH_XXX are internal to
> device_handler and should never see the light of day.
>

Thanks for your feedback.
Both scsi_dh_attach() and scsi_dh_set_params() should
return -ENODEV, right?

Thanks,
//richard
