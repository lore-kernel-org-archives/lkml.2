Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0ICJnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:43:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:53046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab0ICJnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:43:12 -0400
Message-ID: <4C80C31D.5020906@kernel.org>
Date: Fri, 03 Sep 2010 11:42:53 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: jaxboe@fusionio.com, snitzer@redhat.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/5] dm: relax ordering of bio-based flush implementation
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-4-git-send-email-tj@kernel.org> <4C808FF4.4010901@ct.jp.nec.com>
In-Reply-To: <4C808FF4.4010901@ct.jp.nec.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 09:42:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/03/2010 08:04 AM, Kiyoshi Ueda wrote:
> Now queue_io() is called from dec_pending(), which may be called with
> interrupts disabled.
> So queue_io() must not enable interrupts unconditionally and must
> save/restore the current interrupts status.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Patch included into the series.  Thanks a lot!

-- 
tejun
