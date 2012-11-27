Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2K0BBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:01:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48577 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab2K0BBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:01:10 -0500
From: Benjamin Segall <bsegall@google.com>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] enable runnable load avg in load balance
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
	<xm26ehjg5gra.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<50B40B49.1070107@intel.com>
Date: Mon, 26 Nov 2012 17:01:07 -0800
In-Reply-To: <50B40B49.1070107@intel.com> (Alex Shi's message of "Tue, 27 Nov
	2012 08:37:29 +0800")
Message-ID: <xm26624r6er0.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran it on tip/sched/core.
