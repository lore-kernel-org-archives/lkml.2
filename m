Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1LHQeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:34:12 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:21822 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1LHQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:34:08 -0500
X-Authority-Analysis: v=2.0 cv=HK9B5/Rv c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=D19gQVrFAAAA:8 a=jN9qw3U5iZ-elwqlHxwA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EE0C814.2000807@cfl.rr.com>
Date: Thu, 08 Dec 2011 09:22:12 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F320.5060709@cfl.rr.com> <20111208123038.GA16493@nb.redhat.com>
In-Reply-To: <20111208123038.GA16493@nb.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/2011 7:30 AM, Karel Zak wrote:
>   It seems very close to Vivek's BLKPG_EXTEND_PARTITION idea, see:
>
>      https://lkml.org/lkml/2011/9/1/351
>
>   It's evident that we (userspace) need something better than
>   BLKPG_{ADD,DEL}_* and BLKRRPART, but no response from kernel side :-(

Yes, this looks very similar to mine, except that I also wanted to allow 
shrinking the partition, not just extending, since btrfs can handle this 
( tested ).

