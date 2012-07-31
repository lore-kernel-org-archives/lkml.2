Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2GaRwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:52:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2GaRv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:51:59 -0400
Date: Tue, 31 Jul 2012 10:51:54 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Roland Dreier <roland@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 15/15] workqueue: deprecate __cancel_delayed_work()
Message-ID: <20120731175154.GB21292@google.com>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
 <1343433308-26614-16-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343433308-26614-16-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is dropped for now as cancel_delayed_work() cannot be
called from irq context as pointed out by Tomi Valkeinen.  git branch
accordingly updated.  I'm working on another patchset to remove the
restriction.

Thanks.

-- 
tejun
