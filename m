Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1GAAl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:41:28 -0400
Received: from mta31.charter.net ([216.33.127.82]:59264 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1GAAl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:41:26 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=XYJHFtupD_QA:10 a=mcX5mxNah78A:10 a=HnXbG3lm2xYA:10
 a=51s7TfUde-YA:10 a=lDGNyK2vIvEA:10 a=kj9zAlcOel0A:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=DQK736fmfM6KF5IPgTIA:9 a=CjuIK1q_8ugA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Date: Thu, 30 Jun 2011 19:41:21 -0500
From: Greg Dietsche <greg@farmergreg.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, Gregory.Dietsche@cuw.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86, smpboot: Mark names[] array as const
Message-ID: <20110701004121.GA18671@farmergreg.com>
Reply-To: Greg Dietsche <greg@farmergreg.com>
References: <1309473108-5337-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <tip-a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94@git.kernel.org>
 <4E0D1400.7020107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0D1400.7020107@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 05:25:36PM -0700, H. Peter Anvin wrote:
> On 06/30/2011 05:21 PM, tip-bot for Greg Dietsche wrote:
> > +	const char const *names[] = { "ID", "VERSION", "SPIV" };
>         ^^^^^^^^^^^^^^^^
> 
> Doesn't make sense, patch removed...
> 	
could you explain a little more? I don't see my mistake.
it compiles and is running on my box currently.

Thanks!
Greg

> 	-hpa
> 
