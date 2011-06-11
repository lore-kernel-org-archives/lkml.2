Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1FKMWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 08:22:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49440 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab1FKMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 08:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lOKedLYunr28b7KsNSWgqUNmL1aUkgqdHU4l0hNtClyozlQWy/gimJLRh/PlWLJE8A
         DpvPxGQM59NEqQECgm3XuZYDpAPjMsfWp51UJazX4Q0JMmGA1he9QIVCZ04ESVYL1nNb
         lQGL72Wwpl5vrndZW02plgKBW8iMwHVUoP7x8=
Date: Sat, 11 Jun 2011 14:22:20 +0200
From: Tejun Heo <tj@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com,
        isimatu.yasuaki@jp.fujitsu.com, adobriyan@gmail.com
Subject: Re: [PATCH] fs/partitions/check.c: make local symbols static
Message-ID: <20110611122220.GB7980@mtj.dyndns.org>
References: <201106101526.59686.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106101526.59686.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:26:59PM -0700, H Hartley Sweeten wrote:
> The symbols part_ro_show, part_alignment_offset_show, and
> part_discard_alignment_show are not used outside this file and
> should be marked static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
