Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab2IQSDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:03:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38085 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab2IQSDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:03:10 -0400
Message-ID: <505765F2.1000707@gmail.com>
Date: Mon, 17 Sep 2012 14:03:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Jianpeng Ma <majianpeng@gmail.com>,
        fweisbec <fweisbec@gmail.com>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Tao Ma <boyu.mt@taobao.com>,
        Jens Axboe <axboe@kernel.dk>, kosaki.motohiro@gmail.com
Subject: Re: Why blktrace didn't trace requests merge?
References: <201209171933464847623@gmail.com> <1347888148.13080.20.camel@gandalf.local.home> <20120917175534.GG18677@google.com>
In-Reply-To: <20120917175534.GG18677@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(9/17/12 1:55 PM), Tejun Heo wrote:
> (cc'ing Jens)
> 
> On Mon, Sep 17, 2012 at 09:22:28AM -0400, Steven Rostedt wrote:
>> On Mon, 2012-09-17 at 19:33 +0800, Jianpeng Ma wrote:
>>> Hi all:
>>> 	I used blktrace to trace some io.But i can't find requests merge. I searched the code and did't not find.
>>> 	Why? 
>>> 									
>>
>> No idea. I don't use blktrace much, but I Cc'd those that understand it
>> better than I.

backmerge/fronmerge event?

