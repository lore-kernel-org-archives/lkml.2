Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab0HEWGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:06:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab0HEWGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:06:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=W+2KCJZ4qrzzfPDD6ABwJvcca7+3rWDUvPN88phEoUA3yjfld124wDgUNYPmnU+GR
	KFQ9uLWVgowxmnYXDm2cQ==
MIME-Version: 1.0
In-Reply-To: <20100805132433.d1d7927b.akpm@linux-foundation.org>
References: <1280969004-29530-1-git-send-email-mrubin@google.com> 
	<1280969004-29530-3-git-send-email-mrubin@google.com> <20100805132433.d1d7927b.akpm@linux-foundation.org>
From: Michael Rubin <mrubin@google.com>
Date: Thu, 5 Aug 2010 15:05:57 -0700
Message-ID: <AANLkTik9AMf1pmsguB843UC9Qq6KxBcWiN_qyeiDPp1O@mail.gmail.com>
Subject: Re: [PATCH 2/2] writeback: Adding pages_dirtied and 
	pages_entered_writeback
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 1:24 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  4 Aug 2010 17:43:24 -0700
> Michael Rubin <mrubin@google.com> wrote:
> Wait.  These counters appear in /proc/vmstat.  So why create standalone
> /proc/sys/vm files as well?

I did not know they would show up in /proc/vmstat.

I thought it made sense to put them in /proc/sys/vm since the other
writeback controls are there.
but have no problems just adding them to /prov/vmstat if that makes more sense.

mrubin
