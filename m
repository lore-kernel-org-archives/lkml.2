Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096Ab1AEB1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:27:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58513 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1AEB1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:27:30 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=kRJsYS2HAzkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=DRY8zaNu5eAPE_yWa60A:9 a=ltpKl8NLRIcqrlPiGCo0KbvQE5IA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: trace-cmd: fix python bindings
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@intel.com>
In-Reply-To: <1294173820-7043-1-git-send-email-dvhart@linux.intel.com>
References: <1294173820-7043-1-git-send-email-dvhart@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 04 Jan 2011 20:27:28 -0500
Message-ID: <1294190848.3948.221.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 12:43 -0800, Darren Hart wrote:
> The python bindings stopped working after some changes to trace-cmd. This 
> series addresses the bindings and python object member naming issues. With
> these changes, event-viewer.py and the tracecmd.py self-tests work again.

Applied,

Thanks Darren!

-- Steve


