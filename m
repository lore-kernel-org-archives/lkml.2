Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0F3UN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:13:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab0F3UN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:13:57 -0400
Date: Wed, 30 Jun 2010 13:13:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: MMIO32 support for 8250_early.c
Message-Id: <20100630131321.07d0f921.akpm@linux-foundation.org>
In-Reply-To: <87mxucuyfo.fsf@auriga.deep>
References: <87r5jxva3n.fsf@auriga.deep>
	<20100628134426.0558ac67.akpm@linux-foundation.org>
	<87mxucuyfo.fsf@auriga.deep>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 23:12:43 +0400
Samium Gromoff <_deepfire@feelingofgreen.ru> wrote:

> So, the branch is again updated, and the delta is:

This gives checkpatch a complete heart attack.  Please, use it?
