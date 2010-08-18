Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0HRLmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 07:42:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0HRLmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 07:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VoogLaYs2jVLWveWEzXNHAQr8SRyQU5bBN6iSNhsWNpq2fP9uioN0IUYOsobS/p932
         3nX+Ln1eGoBl7obW0lee+FkSpik6JfgQqPOUJivjxbaM+ejit1VlPUzFxcuErJRSXCSV
         CQRdLOyCf9xRPATfe9btYSol7d3tZNklVrl4g=
Message-ID: <4C6BC72E.6040607@gmail.com>
Date: Wed, 18 Aug 2010 13:42:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com> <20100817223145.GC4641@Krystal>
In-Reply-To: <20100817223145.GC4641@Krystal>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 12:31 AM, Mathieu Desnoyers wrote:
> * Jiri Slaby (jirislaby@gmail.com) wrote:
>> On 08/18/2010 12:09 AM, Mathieu Desnoyers wrote:
>>> This is with these changes applied:
>>
>> Hi, these are very wrong. Please use ones from:
>> http://lkml.org/lkml/2010/8/12/98
> 
> Yep, my system boot fine now.
> 
> Any plans to fast-track these fixes to mainline ?

Neil sent a pull request for the raid fixup earlier today.

James and Jens, could you take the two remaining (SCSI and BLOCK)?

thanks,
-- 
js
