Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0FYVIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:08:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47868 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0FYVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:08:48 -0400
Message-ID: <4C251AFF.70803@colorfullife.com>
Date: Fri, 25 Jun 2010 23:09:19 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <20100621200118.GA4021@nb-core2.darkstar.lan> <4C223657.3030507@colorfullife.com> <AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com> <AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com>
In-Reply-To: <AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 09:22 PM, Luca Tettamanti wrote:
> Argh, "seems" was indeed appropriate. Manfred your patch does
> alleviate the problem but something is still wrong. I noticed (I'm
> developing an ajax heavy web app) that sometimes an apache worker
> hangs; I can reproduce the problem with ab (apache benchmark) and a
> high concurrency level (I'm testing with 100 and 10k requests, and I
> get only 2-5 dropped requests). This does not happen with 2.4.34.
> Any idea on how I can debug this further?
>
>    
Are there still hung httpd processes?

--
     Manfred
