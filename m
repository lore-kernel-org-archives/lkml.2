Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0ITRY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:24:29 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0ITRY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:24:27 -0400
Message-ID: <4C9798D1.9060009@fusionio.com>
Date: Mon, 20 Sep 2010 19:24:33 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3 RESEND] BDI handling fixes
References: <1284997471-9850-1-git-send-email-jack@suse.cz> <4C979896.6050900@kernel.dk>
In-Reply-To: <4C979896.6050900@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-20 19:23, Jens Axboe wrote:
> On 2010-09-20 17:44, Jan Kara wrote:
>>   Hi,
>>
>>   I resend this series because I've messed up Jens' address in the original
>> posting. Jens, would you please include these fixes in your tree? Thanks.
>> The series of these three patches fixes the warning in __mark_inode_dirty()
>> which happens when I do e.g. touch /dev/zero.
> 
> Thanks, I'll commit for .37 and tag the for stable.

Actually, I think they are fine for .36 directly. Agree?

-- 
Jens Axboe

