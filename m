Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2ILNPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:15:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2ILNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:15:53 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3zb4w_T8uCcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=aoBNqm_NXbgA:10 a=zd2uoN0lAAAA:8 a=zR3H0BuV4kAY-_DT6AcA:9 a=PUjeQqilurYA:10 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347455750.10751.36.camel@gandalf.local.home>
Subject: Re: [PATCH] plist: Make plist test announcements KERN_DEBUG
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 12 Sep 2012 09:15:50 -0400
In-Reply-To: <1347446330-6378-1-git-send-email-bp@amd64.org>
References: <1347446330-6378-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 12:38 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> They show up in dmesg
> 
> [    4.041094] start plist test
> [    4.045804] end plist test
> 
> without a lot of meaning so hide them behind debug loglevel.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


