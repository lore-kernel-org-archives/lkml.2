Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2HOFna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 01:43:30 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:47293 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2HOFn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 01:43:28 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <52632.162.105.80.111.1345009372.squirrel@mprc.pku.edu.cn>
In-Reply-To: <20120814153413.GA18601@localhost>
References: <20120814153413.GA18601@localhost>
Date: Wed, 15 Aug 2012 13:42:52 +0800 (CST)
Subject: Re: [PATCH] select GENERIC_ATOMIC64 for c6x/score/unicore32 archs
To: "Fengguang Wu" <fengguang.wu@intel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, "Mark Salter" <msalter@redhat.com>,
        "Aurelien Jacquiot" <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        "Lennox Wu" <lennox.wu@gmail.com>, "Guan Xuetao" <gxt@mprc.pku.edu.cn>
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry I have no compilers for build testing these changes, however the
> risk looks low and it's much better than to leave the arch broken,
> considering that Eric will do atomic64_t in the core fs/namespace.c code.
>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
It looks ok for unicore32.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

