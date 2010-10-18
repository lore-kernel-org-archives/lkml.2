Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0JRJKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:10:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60777 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0JRJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:10:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Subject: Re: oom_killer crash linux system
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
In-Reply-To: <1287389631.1997.9.camel@myhost>
References: <20101018021126.GB8654@localhost> <1287389631.1997.9.camel@myhost>
Message-Id: <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Oct 2010 18:10:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> i want to test the oom-killer. My desktop (Dell optiplex 780, i686
> kernel)have 2GB ram, i turn off the swap partition, and open a huge pdf
> files and applications, and let the system eat huge ram.
> 
> in 2.6.35, i can use ram up to 1.75GB,
> 
> but in 2.6.36-rc8, i just use to 1.53GB ram , the system come very slow
> and crashed after some minutes , the DiskIO is very busy. i see the
> DiskIO read is up to 8MB/s, write just only 400KB/s, (see by conky).
> 
> what change between 2.6.35 to 2.6.36-rc8? is it low performance about
> page reclaim and page writeback in high press ram useage?

very lots of change ;)
can you please send us your crash log?



