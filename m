Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0CUStS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0CUStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:49:17 -0400
Date: Sun, 21 Mar 2010 19:47:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] make task_struct->signal stable, final cleanups
Message-ID: <20100321184748.GA29065@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple conclusive cleanups.


The next step is cleanup the remaining users of signal->count.

Oleg.

