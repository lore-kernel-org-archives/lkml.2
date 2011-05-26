Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1EZDSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:18:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51759 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab1EZDSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bLeaOb0shuPBv/lhupoZeh49rfOrebRJIf855t56bYp8TRHH6ckZFxxJ815/4ZwmOJ
         juOCxcTSdIJK/m/igshZlKXYWgOokic49T/Z9r1yB5UuINTAC9lRt9/cAm84AL8tglEc
         3oh6NMUCiYQq1/lJwS3a5+ty/UHb+zoXmltZM=
Date: Thu, 26 May 2011 11:17:54 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signal.c: fix kernel-doc warning
Message-ID: <20110526031746.GA2473@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20110525192815.01c9227f.randy.dunlap@oracle.com>
 <20110526025806.GA2426@gmail.com>
 <4DDDC2A5.4030703@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <4DDDC2A5.4030703@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 08:01:57PM -0700, Randy Dunlap wrote:
> On 05/25/11 19:58, Harry Wei wrote:
> > On Wed, May 25, 2011 at 07:28:15PM -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Fix kernel-doc warnings in signal.c:
> >>
> >> Warning(kernel/signal.c:2374): No description found for parameter 'nset'
> >> Warning(kernel/signal.c:2374): Excess function parameter 'set' description in 'sys_rt_sigprocmask'
> > Hi Randy,
> > 	I wonder how you can get the warning of the comments.
> > IMO, gcc can not get the comments' errors or warnings. Maybe
> > you just use scripts for this. Would you mind telling me ;)
> 
> Harry,
> 
> I just run "make htmldocs" and watch the messages.
Oh, i see, thanks.

Harry Wei
