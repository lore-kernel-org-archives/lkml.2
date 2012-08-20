Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2HTSXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:23:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60658 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2HTSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:23:03 -0400
Date: Mon, 20 Aug 2012 11:22:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Drewry <wad@chromium.org>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: root=PARTUUID for MBR/NT disk signatures?
Message-ID: <20120820182254.GQ24861@google.com>
References: <502EC16C.4030007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502EC16C.4030007@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 17, 2012 at 04:10:52PM -0600, Stephen Warren wrote:
> I was considering extending the kernel command-line option
> root=PARTUUID= to also support MBR (NT disk signatures). I was thinking
> of a syntax along the lines of:
> 
> root=PARTUUID=UUUUUUUU-PP[/PARTNROFF=%d]
> 
> ... where UUUUUUUU is the hex representation of the NT disk signature,
> and PP is the hex representation of the partition number. Like GPT,
> /PARTNROFF could be used too if desired.
> 
> Related, I was thinking of changing struct partition_meta_info's uuid
> field to be a string, so that it could simply be strcmp'd against the
> UUID value on the kernel command-line. That way, the type of the UUID is
> irrelevant.
> 
> Does anyone have any objection to that?

Wouldn't that be able to break setups which work currently?

Thanks.

-- 
tejun
