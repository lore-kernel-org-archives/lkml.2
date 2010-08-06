Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab0HFNhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:37:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:55924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761334Ab0HFNhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:37:34 -0400
Message-ID: <4C5C1011.6080209@kernel.org>
Date: Fri, 06 Aug 2010 15:37:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] percpu: remove address_space attribute if !SMP
References: <1281098768-5724-1-git-send-email-namhyung@gmail.com>	 <4C5C04D8.1080103@kernel.org> <1281099197.1655.11.camel@leonhard>	 <4C5C06A6.7070206@kernel.org> <1281101014.1655.20.camel@leonhard>
In-Reply-To: <1281101014.1655.20.camel@leonhard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 13:37:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/06/2010 03:23 PM, Namhyung Kim wrote:
> Sure. :-)
> Although I'm not sure that it is really needed, if so I'll do that.

Well, the whole __percpu markup thing is to detect misuse of percpu
pointers.  I think it would definitely be better to have the sanity
check for UP code too.  It's not like it's gonna cost any runtime
overhead and all the needed pieces are already there.

Thanks.

-- 
tejun
