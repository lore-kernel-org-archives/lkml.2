Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3AHOgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:36:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23897 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3AHOgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:36:09 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=2wr-velEPUYA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=sLn8fioLY6AA:10 a=48HGGrAkuzIHLarGKNcA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 8 Jan 2013 09:36:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: kernel BUG at kernel/sched_rt.c:493!
Message-ID: <20130108143605.GB5594@home.goodmis.org>
References: <20130105174632.GB19226@u1004.rgmadvisors.com>
 <20130107175818.GA3411@BohrerMBP.rgmadvisors.com>
 <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I've also managed to reproduce this on 3.8.0-rc2 so it appears the bug
> is still present in the latest kernel.

Shawn,

Can you send me your .config file.

Thanks,

-- Steve
