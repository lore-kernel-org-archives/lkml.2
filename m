Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab1F3HIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:08:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47842 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1F3HId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110629064635.GB678@in.ibm.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
	<1308911347.531.56.camel@gandalf.stny.rr.com>
	<4E074671.7060100@hitachi.com>
	<20110627100104.GA24705@in.ibm.com>
	<BANLkTimYej4_dmBqvPBCLej=JA5atLrZVA@mail.gmail.com>
	<20110629064635.GB678@in.ibm.com>
Date: Thu, 30 Jun 2011 15:08:32 +0800
Message-ID: <BANLkTi=XZuV+UgBT9xdQ14YYL=16fwXvuA@mail.gmail.com>
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Yong Zhang <yong.zhang0@gmail.com>
To: ananth@in.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org,
        galak@kernel.crashing.org, yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 2:46 PM, Ananth N Mavinakayanahalli
<ananth@in.ibm.com> wrote:
>
> Certain functions are off limits for probing -- look for __kprobe

Yup.

> annotations in the kernel. Some such functions are arch specific, but
> show_interrupts() would definitely not be one of them. It works fine on
> my (64bit) test box.
>
> At this time, I think your best bet is to work with the eldk folks to
> narrow down the problem.

I'll give a try :)

> Given the current set of data, I am inclined to
> think it could be an eldk bug, not a kernel one.

Maybe, but the fact is if I don't use kprobe, things works
very well.

I'll be back if there is any update :)

Thanks,
Yong

-- 
Only stand for myself
