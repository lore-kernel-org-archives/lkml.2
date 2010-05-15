Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0EOTWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 15:22:19 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:40354 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0EOTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 15:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XjlUq/kTpNcoOnD4TMR9X6BM2CRUj+sAx+DPuzvxizMMmAslVIKhdduUppRvyJmAL4
         yWb0fHY49V4rCiROfinnJVd8wckbeglblEVrRRvgks/ATU4iUbyPNQsNhEvX3dGcbpaE
         E9yRtTZ/vdLu5TX0eQA4hxuIeE8yMwTKwwyzA=
Message-ID: <4BEEF467.9030300@garzik.org>
Date: Sat, 15 May 2010 15:22:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net,
       bzolnier@gmail.com
Subject: Re: [PATCH 7/8] libata: use the enlarged capacity after late HPA
 unlock
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <1273946974-29131-8-git-send-email-tj@kernel.org>
In-Reply-To: <1273946974-29131-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2010 02:09 PM, Tejun Heo wrote:
> After late HPA unlock, libata kept using the original capacity
> ignoring the new larger native capacity.  Enlarging device on the fly
> doesn't cause any harm.  Use the larger native capacity instead.  This
> will enable on-demand HPA unlocking.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Ben Hutchings<ben@decadent.org.uk>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


