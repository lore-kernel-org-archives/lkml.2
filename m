Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2KHT02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:26:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2KHT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:26:27 -0500
Date: Thu, 8 Nov 2012 11:26:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/8] aoe: avoid running request handler on plugged queue
Message-Id: <20121108112625.2db76c8c.akpm@linux-foundation.org>
In-Reply-To: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012 11:29:32 -0500
Ed Cashin <ecashin@coraid.com> wrote:

> Signed-off-by: Ed Cashin <ecashin@coraid.com>

Could you please prepare decent changelogs for the patches?  Several of
these appear to be bugfixes but we have no description of the
user-visible behavioural changes.  So nobody knows what the patches do,
nor which kernel version(s) they should be merged into.

Thanks.
