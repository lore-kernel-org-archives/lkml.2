Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2INFkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:40:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56384 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2INFkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:40:49 -0400
Date: Fri, 14 Sep 2012 07:40:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH 2/4] perf stat: add compile-time option to disable
 --big-num
Message-ID: <20120914054043.GA9043@gmail.com>
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
 <1347574063-22521-3-git-send-email-irina.tirdea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347574063-22521-3-git-send-email-irina.tirdea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Irina Tirdea <irina.tirdea@gmail.com> wrote:

> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> In printf's format, ' is used to group the output with thousands' grouping
> characters for decimal conversion. Bionic does not support ' for printf.

Please try to solve compatibility without affecting the default 
output and big num is the default perf stat output.

Could the big num output be implemented within perf, without 
relying on glibc's printf implementation?

Thanks,

	Ingo
