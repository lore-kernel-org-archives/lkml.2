Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab2DJTqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2DJTqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:46:17 -0400
Date: Tue, 10 Apr 2012 21:45:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] 3rd resend: kill __task_cred()->task_is_dead()
Message-ID: <20120410194554.GA7196@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The patch was acked by David on 2011-09-20, see
http://marc.info/?l=linux-kernel&m=131653612415506

I didn't dare to keep this ack because the change in cred.h
was updated.

task_is_dead() must die ;) Another user, usbip, was already
fixed in the staging git.

Oleg.

