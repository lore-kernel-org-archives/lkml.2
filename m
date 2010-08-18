Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0HROgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:36:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35255 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0HROgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EPqA1cjcKPcEfEyRsjxCEu/crzRG7vIaZX1Un/0eT/SMKEw+Gj7+do4OkJJlz+o2U/
         SwY9NgmH2ujAtr4pohsjwE3Qv3eAfL42mLMTH5cYL67zBXc+8Zc08rKCsSPUsdSyl2dV
         +Yk6ojQB021ikZ7/cYjk9Aa3ySiMls5UojwII=
Message-ID: <4C6BEFD1.8010200@gmail.com>
Date: Wed, 18 Aug 2010 16:36:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com,
        LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com>	 <20100817223145.GC4641@Krystal>  <4C6BC72E.6040607@gmail.com> <1282141930.3035.9.camel@mulgrave.site>
In-Reply-To: <1282141930.3035.9.camel@mulgrave.site>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 04:32 PM, James Bottomley wrote:
>> James and Jens, could you take the two remaining (SCSI and BLOCK)?
> 
> Sure ... could you identify the email by subject, please? lkml.org seems
> to be down this morning.

Sure:
[PATCH v2] BLOCK: fix bio.bi_rw handling
and
[PATCH v2] SCSI: fix bio.bi_rw handling

You should have received one copy to your suse.de inbox, if everything
worked.

thanks,
-- 
js
