Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab0JANFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:05:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:53268 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab0JANFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:05:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Seblu <seblu@seblu.net>
Subject: Re: 2.6.36-rc5 i915 regression
Date: Fri, 1 Oct 2010 13:01:47 +0000 (UTC)
Message-ID: <loom.20101001T150022-243@post.gmane.org>
References: <201010011300.06298.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 82.234.72.62 (Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.472.62 Safari/534.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Hirte <johannes.hirte <at> fem.tu-ilmenau.de> writes:

> With 2.6.36-rc5 and later my netbook is unusable.


I've the same kind trouble with -rc6 and my dell e6410 (no external screen). 
When module i915 is 
loaded screen become black and i loose the hand on the system.

I don't have log message probably because my i915 is loaded in initrd and
kernel should crash before it's write something. 
If you need more investigation, i can provide it.

Regards,

-- 
Sebastien Luttringer


