Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1JKNmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:42:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37914 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1JKNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:42:30 -0400
Message-ID: <4E9447C2.20707@garzik.org>
Date: Tue, 11 Oct 2011 09:42:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: Amit Sahrawat <amit.sahrawat83@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine
 fails
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com> <4E941D5E.6060101@suse.de>
In-Reply-To: <4E941D5E.6060101@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 06:41 AM, Hannes Reinecke wrote:
> ATA_16 is a rather recent command, and most older drives simply can't
> cope with this. Instead they just kick the error handler and go offline
> eventually.

I tend to agree...  there are a great many USB drives out there, and 
this has not really been tested with a large test selection, has it?

	Jeff


