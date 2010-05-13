Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab0EMPyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:54:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39508 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab0EMPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rutxzuyi2sR7mP3VuLXgKBDvBuooCXruyITvkke9Gyp7x2Fdz90nhEbuPPGXNVV5Ef
         9btJ44gCMYAhnEkrcmJ7Rw/QXCfeu3zPy4XFKGyqwywS6mBb3ZOdcA0hElYBas1b1eew
         ZvwejNFsWznfUU9WkFesXdzBQt/ObFEnq9QF0=
Date: Thu, 13 May 2010 23:58:39 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scripts/get_maintainer.pl: add
 .get_maintainer.conf default options file
Message-ID: <20100513155839.GE5132@cr0.redhat.com>
References: <cover.1273466698.git.joe@perches.com>
 <61106722b46cbf707d3e2641765aae2db93b6ea7.1273466698.git.joe@perches.com>
 <20100512063042.GB5718@cr0.nay.redhat.com>
 <20100512112549.650b321c@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100512112549.650b321c@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:25:49AM +0200, Florian Mickler wrote:
>On Wed, 12 May 2010 14:30:42 +0800
>Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Sun, May 09, 2010 at 09:56:03PM -0700, Joe Perches wrote:
>> >Allow the use of a .get_maintainer.conf file to control the
>> >default options applied when scripts/get_maintainer.pl is run.
>> >
>> >.get_maintainer.conf can contain any valid command-line argument.
>> >
>> >File contents are prepended to any additional command line arguments.
>> >
>> >Multiple lines may be used, blank lines ignored, # is a comment.
>> 
>> Do we really have to do this? This looks odd to me.
>
>it's a little hackish, but the code impact is small. if you prefer
>standard config-file syntax (i.e. "bla=" ) check the patch below. 
>

Better somwhat, but...

>joe, what do you think?
>
>> If the user of get_maintainer.pl uses some long command line
>> arguments, to save his input, he should use bash aliases, not
>> configure files. I never see configure files used like this.
>
>bash aliases don't work (at least here) with "git send-email --cc-cmd="
>
...
>> 
>> Also, it doesn't worthy a configure file for such a script like
>> get_maintainer.pl.
>
>hm.. the only other way to use it via git send-email would be a wrapper
>script? 
>

I still think we should avoid config files as possible as we can.

Thanks.
