Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3AGXLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:11:53 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39543 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3AGXLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:11:51 -0500
X-Greylist: delayed 86687 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2013 18:11:51 EST
Message-ID: <50EB5636.4080705@linaro.org>
Date: Tue, 08 Jan 2013 00:11:50 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: please cleanup the cpuidle tree
References: <20130108092751.4bd60a67280e284369553c18@canb.auug.org.au>
In-Reply-To: <20130108092751.4bd60a67280e284369553c18@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 11:27 PM, Stephen Rothwell wrote:
> Hi Daniel,
> 
> All the commits in the cpuidle tree have been included upstream before
> v3.6-rc1.  They were rewritten before being merged upstream and so are
> now causing merge conflicts in linux-next.  Could you please reset the
> head of your tree
> (git://git.linaro.org/people/dlezcano/cpuidle-next.git#cpuidle-next) to
> be somewhere in the tree that yours is merged into (pm or Linus').

Sure. I believe it is done now.

> Alternatively, if you are not using it any more, let me know and I will
> remove it from linux-next.

I am planning to do some more cleanup in a very near future. So I prefer
to keep it untouched for now.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

