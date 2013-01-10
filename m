Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3AJRER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:04:17 -0500
Received: from mail1.windriver.com ([147.11.146.13]:40901 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3AJREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:04:16 -0500
Message-ID: <50EEF453.9040106@windriver.com>
Date: Thu, 10 Jan 2013 12:03:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [v2.6.34-stable 60/77] udf: Avoid run away loop when partition
 table length is corrupted
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>  <1357688156-25387-61-git-send-email-paul.gortmaker@windriver.com> <1357829004.4514.1.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1357829004.4514.1.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-01-10 09:43 AM, Ben Hutchings wrote:
> On Tue, 2013-01-08 at 18:35 -0500, Paul Gortmaker wrote:
>> From: Jan Kara <jack@suse.cz>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.
>>
>> Check provided length of partition table so that (possibly maliciously)
>> corrupted partition table cannot cause accessing data beyond current buffer.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> [PG: in 2.6.34 udf_err() is called udf_error()]
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> [...]
> 
> There's a follow-up I think you should add:
> 
> commit 57b9655d01ef057a523e810d29c37ac09b80eead
> Author: Jan Kara <jack@suse.cz>
> Date:   Tue Jul 10 17:58:04 2012 +0200
> 
>     udf: Improve table length check to avoid possible overflow
> 
> Ben.

Thanks Ben for the review and the addition; I've queued this
one as well.

Paul.
--

> 
