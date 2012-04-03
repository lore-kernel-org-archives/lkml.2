Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2DCW2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:28:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38955 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2DCW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:28:43 -0400
Date: Tue, 03 Apr 2012 18:28:22 -0400 (EDT)
Message-Id: <20120403.182822.530336438141782843.davem@davemloft.net>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][PATCH V4 1/3] bpf jit: Make the
 filter.c::__load_pointer helper non-static for the jits
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F7B7911.5090307@googlemail.com>
References: <4F75CC63.10405@googlemail.com>
	<20120403.180212.1644422418766062447.davem@davemloft.net>
	<4F7B7911.5090307@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 15:28:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Seiffert <kaffeemonster@googlemail.com>
Date: Wed, 4 Apr 2012 00:26:25 +0200

> Is that the preferred comment style in net/ ? Coding style says
> first line empty. Or just to match the rest of the file?

I'm not getting into this discussion right now, sorry.
