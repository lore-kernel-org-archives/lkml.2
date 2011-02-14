Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1BNQ7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:59:04 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51086 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1BNQ64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:58:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=AG65AhO5ExyNDCFi9EdpLVg5Nw0WBv1Q1nH22dNlcdtmTyYeldzDQ6NoY0kfWoyDEp
         xB3RiT8oSgoWhhHjwh27hdqslfUNglFz+hm8FuvQ+LG1eOhDrMDw0IC1pPxvz2KytsNg
         klc8qghno6bPa+GXewN7HoBz47nfikKP3Mhjw=
MIME-Version: 1.0
In-Reply-To: <m1fwrrtc0m.fsf@fess.ebiederm.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <m1hbce46fw.fsf@fess.ebiederm.org> <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
 <m1bp2ly41q.fsf@fess.ebiederm.org> <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
 <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
 <AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
 <m14o87wev8.fsf@fess.ebiederm.org> <AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
 <m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 14 Feb 2011 11:58:28 -0500
X-Google-Sender-Auth: zquYKqw7Lf-BkvWqKYHDKV9PPsE
Message-ID: <AANLkTiko+Rsaf4-erkXdriGhSSt8DFptTaMBWd7ZsotA@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, crash-utility@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Eric,

On Mon, Feb 14, 2011 at 12:34 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> And for completeness.  When I was rebooting v2.6.38-rc4 to start running
> 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505  I hit this.
>
> Sigh.  I wish crash worked on something besides redhats enterprise
> kernels.  Then I could use the system core file I have to do more than
> extract the dmesg.

Then you should cc crash-utility@redhat.com (now cc'd) and work with
Dave Anderson (e.g. get him your vmlinux and core files, which version
of crash you're using and how it fails).  Dave does an amazing job of
working through crash issues which are reported against upstream
kernels -- the key first step is the report.

Mike
