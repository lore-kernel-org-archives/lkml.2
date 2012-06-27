Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2F0RzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:55:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab2F0RzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:55:02 -0400
Date: Wed, 27 Jun 2012 10:54:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120627175458.GL15811@google.com>
References: <20120626125953.GA22557@redhat.com>
 <CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
 <20120626155332.GJ22557@redhat.com>
 <CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
 <20120626205651.GW3869@google.com>
 <CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
 <CAKA=qzaZweeeYUFD2OHDeAO-SQihSvExAZ=ZnXeY5o5sMWpxJg@mail.gmail.com>
 <CAKA=qzbaM-z7CbASUgq-A7CZWiUq6pdb93e4giYAw63hQK=MCg@mail.gmail.com>
 <20120627173822.GK15811@google.com>
 <CAKA=qzY5FT8rWU=z8DwGB7aF6AvCuT=bH2sOJQafyEPqtbkduQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzY5FT8rWU=z8DwGB7aF6AvCuT=bH2sOJQafyEPqtbkduQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:44:04PM -0500, Josh Hunt wrote:
> Awesome, thanks!

One question tho.  The system was pretty heavily loaded (CPU-wise)
when the hiccup happened, right?

Thanks.

-- 
tejun
