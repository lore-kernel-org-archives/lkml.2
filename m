Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1LABpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:45:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1LABph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:45:37 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=GDqlaHrt3F0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=ag1SF4gXAAAA:8 a=QyXUC8HyAAAA:8 a=NuR9I07YEHnq6tbO0oMA:9 a=8iCNTsjIzWhRSyIdHpUA:7 a=QEXdDO2ut3YA:10 a=1TSTQ8KKaH4A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] trace-cmd: Cross-compile fixes for LDFLAGS and include
 path
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
In-Reply-To: <4ED6C808.9030003@linux.intel.com>
References: <4ED6C808.9030003@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 20:45:35 -0500
Message-ID: <1322703935.30977.2.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 16:19 -0800, Darren Hart wrote:
> Add ability for the Makefile to respect LDFLAGS.
> Also remove hardcoded /usr/local/include include path.
> 
> Signed-off-by: Richard Purdie <richard.purdie@linuxfoundation.org>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> 

Applied, thanks!

-- Steve


