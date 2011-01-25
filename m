Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1AYNGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:06:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53274 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1AYNGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rva5+Ftqf/4agOezno3OEZ70dU66xEicbMSPmPzsGaQi5m+xye3CVD4Es8g1LA/0Mx
         xQ4GZiGWSaeCa132W1Z/tCxYY/WY2H+iRvn88q8EoQ2lJaYwCg4KbzuIPL829cTcTPS+
         meSoOHEC8SAY6/dwRraBY2odSOkR1yhFd+hE0=
Date: Tue, 25 Jan 2011 14:06:38 +0100
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCHSET] block: convert block drivers to ->check_events()
Message-ID: <20110125130638.GS27510@htj.dyndns.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Tue, Dec 28, 2010 at 06:28:56PM +0100, Tejun Heo wrote:
>  0001-block-don-t-implicitly-trigger-event-check-on-disk_u.patch
>  0002-block-don-t-check-events-on-close-unless-it-was-bloc.patch
>  0003-block-don-t-check-events-while-open-is-in-progress.patch
>  0004-ide-convert-to-bdops-check_events.patch
>  0005-floppy-ami-ata-flop-convert-to-bdops-check_events.patch
>  0006-gdrom-viocd-convert-to-bdops-check_events.patch
>  0007-paride-convert-to-bdops-check_events.patch
>  0008-dac960-convert-to-bdops-check_events.patch
>  0009-swim-3-convert-to-bdops-check_events.patch
>  0010-ub-convert-to-bdops-check_events.patch
>  0011-xsysace-convert-to-bdops-check_events.patch
>  0012-i2o_block-convert-to-bdops-check_events.patch
>  0013-s390-tape_block-convert-to-bdops-check_events.patch
>  0014-umem-drop-dummy-media_changed.patch
>  0015-pktcdvd-convert-to-bdops-check_events.patch
>  0016-staging-convert-to-bdops-check_events.patch

This series seems to have been forgotten.  I think 0001-0003 better go
in for 2.6.38 as they affect user-visible behavior (in not too
significant way but still).

The other patches can go in for 2.6.39.  0005 gets an easy-to-resolve
context conflict but all other patches apply as-is.  I'll post the
refreshed version of 0005 as a reply to the original patch.  If you
want the whole series reposted, please let me know.

Thank you.

-- 
tejun
