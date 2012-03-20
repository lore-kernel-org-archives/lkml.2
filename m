Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2CTJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:25:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48946 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2CTJZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:25:24 -0400
Message-ID: <4F684D00.4040102@suse.cz>
Date: Tue, 20 Mar 2012 10:25:20 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Slaby <jirislaby@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
References: <cover.1331856299.git.joe@perches.com>  <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>  <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>  <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>  <4F684673.1050309@suse.cz> <1332235315.7847.63.camel@joe2Laptop>
In-Reply-To: <1332235315.7847.63.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 10:21 AM, Joe Perches wrote:
> On Tue, 2012-03-20 at 09:57 +0100, Jiri Slaby wrote:
>> And BTW setting the argument that it is a newer interface (that is what
>> ath5k pr_* conversion patches commit log says) is not a good
>> justification at all.
> 
> No again, the ath5k pr_ conversion patches are to
> standardize prefixes and to reduce code size by
> centralizing tests.

What is the "standard" prefix?

> https://lkml.org/lkml/2012/3/18/121
> https://lkml.org/lkml/2012/3/18/123
> https://lkml.org/lkml/2012/3/18/124
> 
> I happen to like 30K/10+% code size reductions.

Obvious question: what speed reduction does this bring?

thanks,
-- 
js
suse labs
