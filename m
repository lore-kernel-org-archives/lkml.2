Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1HXD6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:58:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab1HXD6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:58:04 -0400
Date: Tue, 23 Aug 2011 23:58:01 -0400
From: Dave Jones <davej@redhat.com>
To: Steevven1 <steevven1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug Report for Linux Kernel 3.x
Message-ID: <20110824035800.GA30312@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steevven1 <steevven1@gmail.com>, linux-kernel@vger.kernel.org
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 07:19:35PM -0400, Steevven1 wrote:
 > Hello,
 > 
 > I would like to report what myself and several others believe to be a
 > serious bug affecting all Linux kernels 3.0 and up, and none below 3.0
 > (2.6.x and lower).
 > 
 > One-sentence description: On certain hardware, the 3.x series kernels
 > drain a considerable amount more power than the 2.6-series kernels, up
 > to 40% more, even when idle.
 >
 > The specific hardware I have personally tested is a Lenovo ThinkPad
 > X220 with an Intel SandyBridge i7 2620M processor.
 
Sounds like https://bugzilla.redhat.com/show_bug.cgi?id=727579
Try booting with i915.i915_enable_rc6=1
 
	Dave

