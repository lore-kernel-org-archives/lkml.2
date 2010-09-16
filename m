Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0IPMyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:54:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0IPMyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:54:43 -0400
Message-ID: <4C921385.2080205@redhat.com>
Date: Thu, 16 Sep 2010 14:54:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Kulikov Vasiliy <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>	<20100905190139.GA3163@merkur.ravnborg.org>	<20100905192335.GA8140@albatros>	<20100905203908.GA3228@merkur.ravnborg.org> <20100906152931.1d4a1d07@notabene>
In-Reply-To: <20100906152931.1d4a1d07@notabene>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 08:29 AM, Neil Brown wrote:
> I've taken the opportunity to substantially re-write that code.
>
>

It's better to have two patches, one a backportable one liner that fixes 
the bug, the other, on top, that cleans up the code but has no sematic 
changes.

This makes it substantially easier to review.  When considering the 
first patch you see the change plainly.  When reviewing the second patch 
you make sure no semantic changes were made at all.

-- 
error compiling committee.c: too many arguments to function

