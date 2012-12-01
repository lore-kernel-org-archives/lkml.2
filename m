Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2LATN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 14:13:28 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53809 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2LATN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 14:13:27 -0500
Date: Sat, 1 Dec 2012 11:13:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High context switch rate, ksoftirqd's chewing cpu
Message-ID: <20121201191321.GC2685@htj.dyndns.org>
References: <50A78AA9.5040904@iskon.hr>
 <20121130225200.GB6021@htj.dyndns.org>
 <20121130225545.GC6021@htj.dyndns.org>
 <50B9E4C1.2050002@iskon.hr>
 <20121201143852.GA2685@htj.dyndns.org>
 <50BA3A2E.9020303@iskon.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BA3A2E.9020303@iskon.hr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Dec 01, 2012 at 06:11:10PM +0100, Zlatko Calusic wrote:
> Sure. Please clarify, should I apply it on top of the previous one
> or standalone?

It's a replacement, so by itself.

Thanks!

-- 
tejun
