Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0FKHQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:16:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22721 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0FKHQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:16:39 -0400
Message-ID: <4C11E2BD.2020207@oracle.com>
Date: Fri, 11 Jun 2010 15:16:13 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>, Nick Piggin <npiggin@suse.de>,
       "tao.ma" <tao.ma@oracle.com>
Subject: Re: [PATCH v4] ocfs2: Let ocfs2_setattr use new truncate sequence.
References: <1276226869-11123-1-git-send-email-tao.ma@oracle.com> <20100611065635.GA19692@lst.de>
In-Reply-To: <20100611065635.GA19692@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4C11E2CD.0018:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 06/11/2010 02:56 PM, Christoph Hellwig wrote:
> This looks correct, but still has the second if ATTR_SIZE block that
> I commented on last time.  I'd really prefer if the filesystems could
> move the truncate handling into a single conditional to simplify
> auditing for it and possibly splitting it out into a separate method
> later.
oh, that would be much work for ocfs2 to do from my perspective. So I 
would really want to leave it as-is and I have add it to my to-do list.
>
> And btw, the S_ISREG check which you only have on the first ATTR_SIZE
> check is superflous, the VFS only does ATTR_SIZE calls on regular files.
yeah, I can remove it.

Regards,
Tao
