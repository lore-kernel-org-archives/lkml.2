Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab0JRCCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 22:02:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48783 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0JRCCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 22:02:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 10:57:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, fengguang.wu@intel.com,
        figo1802 <figo1802@gmail.com>
Subject: Re: oom_killer crash linux system
Message-Id: <20101018105722.03415e48.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287366459.2035.1.camel@myhost>
References: <1287366459.2035.1.camel@myhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 09:47:39 +0800
"Figo.zhang" <zhangtianfei@leadcoretech.com> wrote:

> hi all,
> 
> i have a desktop run linux2.6.35 and have 2GB ram. i turn off the swap
> partition, and i open huge applications , let the system eat more and
> more memory.
> when the system eat more than 1.7G ram, the system crashed.
> 

2.6.36-rc series has a completely new logic, please try.

Thanks,
-Kame

