Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589Ab0KQINz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:13:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57356 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523Ab0KQINx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DpKEDpteZPDqOIl1VzHrO9t9fMxD1jPl7DAPjALQVXJeEazqOUiTncu5L9p8Q4vh2e
         oBBAjtRuwJTGCvp5Gn5L928PgJOdQNECo9Jai2ClMS3HaLH/5xOEyZQRDStSz6TKUr6J
         OyejCv6E0XgV7gY/oPcnn5CKyRYs4yKWzaFJQ=
Message-ID: <4CE38EBD.2040606@garzik.org>
Date: Wed, 17 Nov 2010 03:13:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
References: <20101117062958.GA2894@havoc.gtf.org> <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com> <4CE38D70.4010507@garzik.org>
In-Reply-To: <4CE38D70.4010507@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 03:08 AM, Jeff Garzik wrote:
> So maybe an EH expert (Tejun?) can correct me here, but I think we may
> be able to completely the lock/get-serial/unlock sequence from libata,
		^^^ er, completely remove

