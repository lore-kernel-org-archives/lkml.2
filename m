Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1EQOVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:21:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1EQOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:21:31 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=TEquWTb0WnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LrNNOpsM2wWV75mCSJ4A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/2] ftrace/kbuild: Add recordmcount files to
 force full build
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1305642010.5456.730.camel@gandalf.stny.rr.com>
References: <20110517021027.390391519@goodmis.org>
	 <20110517021423.661004726@goodmis.org>
	 <20110517133646.GP13293@sepie.suse.cz>
	 <1305640042.5456.727.camel@gandalf.stny.rr.com>
	 <1305642010.5456.730.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 10:21:30 -0400
Message-ID: <1305642090.5456.732.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 10:20 -0400, Steven Rostedt wrote:

> Awesome! This worked. I wonder what screw up I did to keep mine from
> working? 

Bah! I forgot to add the $() around the variable that I used.

/me is embarrassed.

-- Steve


