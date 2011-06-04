Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1FDGU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 02:20:57 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:51592 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1FDGU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 02:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=qO+/HzNQ4qdmA/vkO/WZI9L4uu0KFH11qPkWUk6x2qkp3gKtDnOAqwREqrh6CqxNaf
         f+ADFbv7z/iUGY0bCOCU7gF1B29TuHSnannxM5Ckc7DtEfUhEniN9JUgXpUJLjIb9u+u
         7ymrc3h/ETGMPcGkfVzD5prPG+5nhOdY1wpOc=
Date: Sat, 4 Jun 2011 14:20:31 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC]Questions about quilt & git quilt
Message-ID: <20110604062024.GA4308@gmail.com>
Mail-Followup-To: Mike Galbraith <efault@gmx.de>,
	linux-kernel@vger.kernel.org
References: <20110604025811.GB2589@gmail.com>
 <1307167005.5426.4.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1307167005.5426.4.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 07:56:45AM +0200, Mike Galbraith wrote:
> On Sat, 2011-06-04 at 10:58 +0800, Harry Wei wrote:
> > Hi all,
> > I wanna read the git quilt's codes, but i can not find
> > them anywhere. Josef Sipek maintain the git quilt, so 
> > i fetch from 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git
> > When i entered guilt directory, i just find only executable files but
> > their codes. Can anyone know how i can get their codes? 
> > Thanks in advance.
> 
> Guilt is a set of executable scripts.
Yeah, you are right.
Thanks for your help, Mike.

Harry Wei
