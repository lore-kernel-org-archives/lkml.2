Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2IUTkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:40:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2IUTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:40:39 -0400
Date: Fri, 21 Sep 2012 12:40:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Deepawali Verma <dverma249@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Work queue questions
Message-ID: <20120921194035.GK7264@google.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
 <20120921174952.GF7264@google.com>
 <CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
 <20120921183515.GI7264@google.com>
 <CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
 <20120921192720.GJ7264@google.com>
 <CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Deepawali.

On Fri, Sep 21, 2012 at 08:35:13PM +0100, Deepawali Verma wrote:
> These three tasks are writing the three chunks of data in parallel. I
> am not getting improvement here otherwise what is difference between
> writing these chunks one by one in single thread instead of trying to
> write the data by scheduling the work on three different workqueues
> means 3 worker threads?

Workqueue is designed to supply sufficient concurrency for such use
cases and it has been doing so for all other in-kernel users for quite
some time now.  If you're not getting concurrency in the above
scenario, either you've found a bug in workqueue or you did something
wrong.  If you have a scenario not working for you, please post the
code.

Thanks.

-- 
tejun
