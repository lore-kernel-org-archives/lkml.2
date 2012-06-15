Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab2FOOWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:22:32 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52131 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FOOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:22:31 -0400
Date: Fri, 15 Jun 2012 10:22:11 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, ben@decadent.org.uk
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Message-ID: <b20e68ee-0e3c-4a44-86e4-734c6205cbbe@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20120615135825.GA12847@elliptictech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.36.112.27]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This should be -stable material as well, as >=3.2.y kernel versions
> are affected (I think 3.0.y is OK?).

Not sure, but -ENOIOCTLCMD needed to be changed to -ENOTTY on some
kernel versions (but the conflicts will make this pretty evident).

Paolo
