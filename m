Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab1ERSvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:51:53 -0400
Received: from mail.tpi.com ([70.99.223.143]:3113 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933509Ab1ERSvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:51:51 -0400
Message-ID: <4DD41544.2030508@canonical.com>
Date: Wed, 18 May 2011 12:51:48 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] 2.6.39-rc7+ fs: Fix spinlock recursion in get_active_super()
References: <20110518163500.5CA99F912D@sepang.rtg.net> <20110518181520.GA17242@infradead.org>
In-Reply-To: <20110518181520.GA17242@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 12:15 PM, Christoph Hellwig wrote:
> How can you reproduce that recursion?  Given that grab_super drops
> sb_lock I can't see any way to hit it.
>

Dang, you're right. Consider it NAKd

rtg
-- 
Tim Gardner tim.gardner@canonical.com
