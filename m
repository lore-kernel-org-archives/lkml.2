Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1FGBEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:04:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49519 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab1FGBD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=wNVF1wxy7P3YtupjL2rJOFI1+yNQQ+iG3mpfDafH2dXatouobi9s3/eS2/mkqR3cmB
         9wLeTMZpSyLrQh0Vlc3+Hxd5qd4uRU7xW02ths8iC0XU8jjju2hD8iEEnAJ2Dvqz0HFv
         py1yK3QQTqMZiezoA2btI2wnrbJRqx8sLIZ4Q=
Date: Tue, 7 Jun 2011 09:03:46 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Oops]RFC:include/trace/events/btrfs.h
Message-ID: <20110607010344.GA8892@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20110605034111.GA7215@gmail.com>
 <20110606134719.b24ecc07.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20110606134719.b24ecc07.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:47:19PM -0700, Randy Dunlap wrote:
> On Sun, 5 Jun 2011 11:41:14 +0800 Harry Wei wrote:
> 
> > From: Harry Wei <harryxiyou@gmail.com>
> > 
> > When i compile 2.6.39.1, it shows something wrong
> > like below. When i open the file include/trace/events/btrfs.h
> > i don't know how to fix these oops. They just give the entry
> > of the function. So i can't get the exact line of the warnings.
> > Can anyone give me some suggestions?
> 
> Yeah, those line numbers (below) don't help very much.
> 
> There is a patch pending to fix these warnings.  It's from
> liubo <liubo2009@cn.fujitsu.com>, posted on 2011-APR-19,
> subject: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid warnings on 32bit machine
>
Yup, it is well for me.

Thanks.
Harry Wei.
