Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0EZPtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:49:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55490 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0EZPtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=d9D4HlP8v/TfyalhIlRoJoOwQUU7FWwuVp5FhigUgsRRvIB8J++nyY7DX2RoEuVVFh
         9O0JHZ55f2JdLnRZL1KbwRrjy/lNG6KQ+FKwK6uhKt4i6N+cHg/OkO/jpGuVKlXihnzA
         o6msr8hSn2/18nXicOcyAItsfO6uySDjLliFA=
Date: Wed, 26 May 2010 17:49:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Chase Douglas <chase.douglas@canonical.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] tracing: remove boot tracer
Message-ID: <20100526154918.GA5299@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu> <1274816768.22648.220.camel@gandalf.stny.rr.com> <20100525201736.GB5370@nowhere> <20100526105753.GA5677@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100526105753.GA5677@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 06:57:53PM +0800, Américo Wang wrote:
> On Tue, May 25, 2010 at 10:17:43PM +0200, Frederic Weisbecker wrote:
> >On Tue, May 25, 2010 at 03:46:08PM -0400, Steven Rostedt wrote:
> >> > CONFIG_BOOT_TRACER=y (no performance impact by default)
> >> 
> >> But this tracer is pretty useless. It gives no more information than
> >> debug_initcalls.
> >
> >
> >
> >Yeah it's pretty useless. And these informations can also be displayed
> >through printk on boot so...
> 
> 
> Then just remove it.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>


Queued, thanks!

