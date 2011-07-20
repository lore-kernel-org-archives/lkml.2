Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1GTTCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1GTTCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:02:36 -0400
Date: Wed, 20 Jul 2011 20:59:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Cc: Balbir Singh <bsingharora@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] 26c4caea "don't allow duplicate entries in listener
	mode" fix
Message-ID: <20110720185959.GA21749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I noticed 26c4caea by accident. Afaics it deserves a couple
of minor fixes/cleanups.

COMPILE TESTED ONLY. Needs review and acks ;)

Can't we kill listener->valid? It seems we can set ->pid = 0
to mark it invalid.

Oleg.

