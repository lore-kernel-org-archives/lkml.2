Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1CQUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:02:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab1CQUC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:02:56 -0400
Date: Thu, 17 Mar 2011 16:02:15 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: make checkpatch warn about memset with swapped arguments.
Message-ID: <20110317200215.GA4084@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20110317045209.GA18656@redhat.com>
 <20110317193645.GD14675@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317193645.GD14675@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 03:36:45PM -0400, Steven Rostedt wrote:

 > > +		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
 > 
 > Wouldn't this be a better regex:
 > 
 > 	if ($line =~ /memset.*\,\s*(0x)?0\s*\)\s*;/)

I dunno, regexps are all gobble-de-gook to me.  Why is it better ?

	Dave
 
