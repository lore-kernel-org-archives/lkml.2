Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1DOPgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:36:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42013 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab1DOPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lt+AIWAFYqIgpWxGMjuEkhFvfM3Dcbv+oxPW77hPnl+OXcvN48UjziE++8zrdR8sS8
         CFt0smcimaCFtQkBjDUIeytfuxt/nHmg8WtwU2M9STTpHPcM5tHtfc+FZj82dkK485X+
         rWO9kyq27Xn6VHOEu5DCCPrjXOBTH6MD1vBU0=
Date: Sat, 16 Apr 2011 00:35:54 +0900
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] x86-64, NUMA: fix fakenuma boot failure
Message-ID: <20110415153554.GA8406@mtj.dyndns.org>
References: <20110414095059.080E.A69D9226@jp.fujitsu.com>
 <20110414150551.GC21397@mtj.dyndns.org>
 <20110415203928.1303.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415203928.1303.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 08:39:01PM +0900, KOSAKI Motohiro wrote:
> From 38f7fa6d48f2025bf620f1b8b27ccc7e0698d653 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 13 Apr 2011 15:47:12 +0900
> Subject: [PATCH] x86-64, NUMA: fix fakenuma boot failure
...
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@linux.intel.com>

Yeap, looks good enough to me.  Ingo, hpa, can one of you guys pick
this up and route it through x86/urgent?

Thank you.

-- 
tejun
