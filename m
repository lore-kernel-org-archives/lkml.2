Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab2CSJC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:02:27 -0400
Received: from mx1.pku.edu.cn ([162.105.129.21]:42097 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754326Ab2CSJCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:02:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -311.044
Message-ID: <4F66F359.4060203@pku.edu.cn>
Date: Mon, 19 Mar 2012 16:50:33 +0800
From: Guan Xueao <gxt@pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 27/38] Disintegrate asm/system.h for Unicore32 [ver #3]
References: <1331868043.1971.10.camel@epip-laptop> <20120315205514.28759.58969.stgit@warthog.procyon.org.uk> <20120315205931.28759.81875.stgit@warthog.procyon.org.uk> <17897.1331889018@redhat.com>
In-Reply-To: <17897.1331889018@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 05:10 PM, David Howells wrote:
> Guan Xuetao<gxt@mprc.pku.edu.cn>  wrote:
>
>> Great work!
>>
>> Based on your patch, I adjusted some tiny bits and it could build
>> successful now. Please see the following:
> Do the upstream binutils and gcc support unicore32 targets?
>
> David
>
Not yet. Sorry for the inconvenience.

Guan Xuetao
