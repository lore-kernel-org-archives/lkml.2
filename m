Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab0ECH6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 03:58:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0ECH6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 03:58:34 -0400
Message-ID: <4BDE8226.3010402@infradead.org>
Date: Mon, 03 May 2010 04:58:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20100412124041.4876c3f9.sfr@canb.auug.org.au>	<20100428110710.cec8acdb.sfr@canb.auug.org.au> <20100503150123.8fab27b1.sfr@canb.auug.org.au>
In-Reply-To: <20100503150123.8fab27b1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Mauro,
> 
> On Wed, 28 Apr 2010 11:07:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> On Mon, 12 Apr 2010 12:40:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> After merging the v4l-dvb tree, today's linux-next build (powerpc
>>> ppc64_defconfig) failed like this:
>>>
>>> drivers/input/input.c: In function 'input_default_setkeycode':
>>> drivers/input/input.c:691: error: 'keycode' undeclared (first use in this function)
>>>
>>> Caused by commit df7ad46fc171965103f02649f6c2f02c6ca8b331 ("Merge branch
>>> 'master' of /home/v4l/bare_trees/v4l-dvb").  The merge resolution is not
>>> quite right.
>>>
>>> I have used the v4l-dvb tree from next-20100409 for today.
>> I am still getting this build failure ...
> 
> Any chance of it being fixed?

Done. 


-- 

Cheers,
Mauro
