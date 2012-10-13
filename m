Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2JMG3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 02:29:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2JMG3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 02:29:08 -0400
Date: Sat, 13 Oct 2012 15:28:57 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>
Cc: Charles Wang <muming.wq@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Charles Wang <muming.wq@taobao.com>, Ingo Molnar <mingo@kernel.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
Message-ID: <20121013062857.GA3250@kroah.com>
References: <2649.121.227.41.141.1350099577.squirrel@mail.lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2649.121.227.41.141.1350099577.squirrel@mail.lemote.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 11:39:37AM +0800, 陈华才 wrote:
> So I still think that "sched: Add missing call to calc_load_exit_idle()"
> should be reverted in 3.5 branch...

3.5 is now end-of-life, with no more releases, everyone should have
moved off of it to 3.6 now, so there's nothing to do here anymore.

thanks,

greg k-h
