Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0KHMiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:38:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39438 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab0KHMiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type:content-transfer-encoding;
        b=c8nda5TqCss5ozQNzrATQupT3UE0hSUSUV23JPBfC32lHokMj39yyMT174TcHwdkpz
         tIIEmDI59xDxwcOjgp343XrbEf04kb4E7B/SPcmCYfBbnWFCuJosr2DVbAtSaS0lWgRx
         xlpLdDNJGVIgRazlCO2E5wjNwgMm8jjUkVm/4=
From: Ben Gamari <bgamari.foss@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: fstat suddenly return -EINVAL [Was: Bus error on make allyesconfig, kernelbuild with HEAD]
In-Reply-To: <20101108101920.GA5527@cr0.nay.redhat.com>
References: <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org> <87tyjtjd7m.fsf@gmail.com> <20101107170700.GA22684@merkur.ravnborg.org> <87mxplypid.fsf@gmail.com> <20101107223056.GA23871@merkur.ravnborg.org> <87lj54raw3.fsf@gmail.com> <20101108101920.GA5527@cr0.nay.redhat.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 08 Nov 2010 07:38:13 -0500
Message-ID: <87d3qgq9ca.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 18:20:02 +0800, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> But fixdep should be compiled by the host compiler...
> 
Very good point.

> So, does this error also occur when you do non-cross compiling on the
> same partition?
> 
Hmm, it seems to be fine when not cross-compiling. Interesting.

> Thanks for your testing!

No worries!

- Ben
