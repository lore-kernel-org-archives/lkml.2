Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab0GHU70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:59:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757320Ab0GHU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:59:23 -0400
Date: Thu, 8 Jul 2010 13:59:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] reduce stack usage of node_read_meminfo()
Message-Id: <20100708135916.590fc493.akpm@linux-foundation.org>
In-Reply-To: <20100708194107.CD45.A69D9226@jp.fujitsu.com>
References: <20100708181629.CD3C.A69D9226@jp.fujitsu.com>
	<20100708194107.CD45.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Jul 2010 19:41:57 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Grr, I did sent old ver. right patch is here ;-)
> sorry.

oop, there it is.  Did you check the output carefully?
