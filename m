Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0FNWoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:44:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:60062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0FNWoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:44:00 -0400
Message-ID: <4C16B085.3030707@kernel.org>
Date: Tue, 15 Jun 2010 00:43:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<20100614145839.8ac7687a.akpm@linux-foundation.org>	<4C16AA75.8030303@kernel.org> <20100614153545.51fe0338.akpm@linux-foundation.org>
In-Reply-To: <20100614153545.51fe0338.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 22:43:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/15/2010 12:35 AM, Andrew Morton wrote:
> Nobody's going to remember all that stuff except yourself, and the info
> might be out of date.  So please update and maintain that information
> and retain it with the patchset.
> 
> eg: "<NEED SOME BACKING NUMBERS>".  And "Please read the patch
> description of the last patch for more details" is out of date.
> 
> Because right now I have a bunch of code in my inbox and little
> (actually "no") idea why anyone might want to merge it into anything.
>
> Trying to review a large patchset when you don't have an overall
> picture of what it's trying to do and how it's trying to do it is
> rather painful - you have to work all that stuff out from the
> implementation.  It's also error-prone if the implementation doesn't
> implement that which the author thinks it implements (ie: if it has
> design bugs).

Well, basics of the whole thing didn't change all that much since the
first take and most people on cc list were cc'd on each take.  The
biggest reason I'm still carrying the whole patchset is due to the
scheduler changes.  The numbers are in the third take (which you can
follow the links to find out).  Anyways, I'll write up another summary
tomorrow.

Thanks.

-- 
tejun
