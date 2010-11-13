Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0KMCJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 21:09:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47592 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0KMCJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 21:09:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qBUxdXimFbUIrRNCrqoDdudUDidywqH2OCtsHN99dnQ5FHWWAn7eVR8Olgeqd44qeD
         HrUm1BB5fgiLPocfHfeXoNOU58pg2IGCCwVJfMqjDAdrBN7fxU8bvo4aMNxGMgBDoi36
         ZZTsmkZI4AlRJfz43GNJUk5ajvszIG/RVfF2A=
Message-ID: <4CDDF34D.7080201@garzik.org>
Date: Fri, 12 Nov 2010 21:09:17 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <4CDDF1DB.1020707@garzik.org>
In-Reply-To: <4CDDF1DB.1020707@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 09:03 PM, Jeff Garzik wrote:
> That [silent breakage issue] is precisely what I mentioned in the original patch:
> http://marc.info/?l=linux-ide&m=128891665713984&w=2
>
> And brought this up again when James merged my patch:
> http://marc.info/?l=linux-scsi&m=128943169802009&w=2

For the record, I prefer a rename to a prototype change.

	Jeff


