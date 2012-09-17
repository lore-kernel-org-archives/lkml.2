Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2IQNWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:22:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2IQNWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:22:30 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-QelYV91yG0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xiWJP1ky0A8A:10 a=xmoyjxuTWcoHOSBJu1UA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347888148.13080.20.camel@gandalf.local.home>
Subject: Re: Why blktrace didn't trace requests merge?
From: Steven Rostedt <rostedt@goodmis.org>
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: fweisbec <fweisbec@gmail.com>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Tao Ma <boyu.mt@taobao.com>
Date: Mon, 17 Sep 2012 09:22:28 -0400
In-Reply-To: <201209171933464847623@gmail.com>
References: <201209171933464847623@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 19:33 +0800, Jianpeng Ma wrote:
> Hi all:
> 	I used blktrace to trace some io.But i can't find requests merge. I searched the code and did't not find.
> 	Why? 
> 									

No idea. I don't use blktrace much, but I Cc'd those that understand it
better than I.

-- Steve


