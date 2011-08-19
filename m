Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1HSKZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:25:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab1HSKZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:25:35 -0400
Message-ID: <4E4E3490.5000404@redhat.com>
Date: Fri, 19 Aug 2011 18:01:52 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andy Grover <agrover@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>,
        Yi Zou <yi.zou@intel.com>, Dan Carpenter <error27@gmail.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [Patch] target: remove needless include of version.h
References: <1313736815-27234-1-git-send-email-amwang@redhat.com> <alpine.LNX.2.00.1108190906280.31857@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1108190906280.31857@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年08月19日 15:07, Jesper Juhl 写道:
> On Fri, 19 Aug 2011, WANG Cong wrote:
>
>> They don't version.h to be compiled. Compiling tested.
>>
>
> Looks more or less identical to the patch I submitted on Aug 1 (and
> earlier) : https://lkml.org/lkml/2011/8/1/309
>
>

Ah, is your patch merged?

Thanks!
