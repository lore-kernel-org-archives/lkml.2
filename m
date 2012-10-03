Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2JCJLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:11:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:38879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JCJLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:11:52 -0400
Message-ID: <506BDECA.90701@kernel.dk>
Date: Wed, 03 Oct 2012 08:44:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd-8.3 updates
References: <8391701.3EY4hQfmFv@fat-tyre>
In-Reply-To: <8391701.3EY4hQfmFv@fat-tyre>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-02 15:02, Philipp Reisner wrote:
> Hi Jens,
> 
> Please consider to pull these changes for the 3.7 merge window.
> 
> Best,
>  Phil
> 
> The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:
> 
>   Linux 3.6 (2012-09-30 16:47:46 -0700)
> 
> are available in the git repository at:
> 
>   git://git.drbd.org/linux-drbd.git for-jens
> 
> for you to fetch changes up to a783d564a1badbb87b3f96aa8df581ed4167a9c9:
> 
>   drbd: log request sector offset and size for IO errors (2012-10-02 14:52:24 +0200)

Not pulled. Two reasons:

- It's late (in the merge window)
- and it's not based off my for-3.7/drivers branch, hence I get a ton of
  unrelated changes with a pull into that branch.

-- 
Jens Axboe

