Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0HXPqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:46:15 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44263 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab0HXPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:46:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to REQ_FLUSH/FUA
Date: Tue, 24 Aug 2010 17:45:34 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: lars.ellenberg@linbit.com, Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <20100823164709.GA31221@lst.de>
In-Reply-To: <20100823164709.GA31221@lst.de>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241745.35242.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 23. August 2010, um 18:47:09 schrieb Christoph Hellwig:
> Phillipp and Lars,
> 
> can you look at the changes in
> 
> 	http://www.spinics.net/lists/linux-fsdevel/msg35884.html
> 
> and
> 
> 	http://www.spinics.net/lists/linux-fsdevel/msg36001.html
> 
> and see how drbd can be adapted to it?  It's one of two drivers still
> missing, and because it's not quite intuitive what it's doing it's
> very hard for Tejun and me to help.

Hi Christoph,

I was able to finish the greater part of the necessary work today.
You can find it there:

git://git.drbd.org/linux-2.6-drbd.git flush-fua

Of course that is based on

git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

REQ_HARDBARRIER is not yet completely eliminated from drbd, but I
am very confident that I will be able to finish that by tomorrow.

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
