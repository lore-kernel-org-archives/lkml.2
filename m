Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718Ab0CPE1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 00:27:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:44633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab0CPE1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 00:27:49 -0400
Message-ID: <4B9F08AC.9030904@kernel.org>
Date: Tue, 16 Mar 2010 13:27:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
References: <4B990496.4020002@kernel.org>
In-Reply-To: <4B990496.4020002@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 04:27:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 11:56 PM, Tejun Heo wrote:
> So, what do you guys think?  Probably-the-right-thing-to-do >544 file
> patch or somewhat-ugly-but-let's-worry-about-it-tommorrow two file
> patch?

Ping, any opinions?

Thanks.

-- 
tejun
