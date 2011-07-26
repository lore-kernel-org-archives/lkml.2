Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1GZHqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:46:05 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:35020 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1GZHqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:46:02 -0400
Subject: Re: [PATCH 1/2] kernel.h: Add DIV_ROUND_UP_ULL usage
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1311664225-20172-1-git-send-email-nab@linux-iscsi.org>
References: <1311664225-20172-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain
Date: Tue, 26 Jul 2011 00:36:41 -0700
Message-Id: <1311665801.17766.237.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 07:10 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Add new DIV_ROUND_UP_ULL macro usage for 32-bit architectures requiring
> unsigned long long division of sectors * dev_max_sectors.
> 

Rebasing to fix the incorrect change log here before pushing.

Thanks,

--nab


