Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2E2WVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:21:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63948 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2E2WU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:20:58 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Unhandled IRQs on AMD E-450
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>
Cc: Josh Boyer <jwboyer@gmail.com>, Borislav Petkov <borislav.petkov@amd.com>,
        andymatei@gmail.com, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CAPRPZsBV-qJswWDfwMYjidEDsRzR-r5TG0or1--k599=Cju+tw@mail.gmail.com>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no> <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no> <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18> <4F97BA60.4080505@ladisch.de> <20120427082203.GB9233@aftab.osrc.amd.com> <CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com> <CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com> <CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com> <CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com> <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com> <4F9E61FC.8070409@ladisch.de> <CAPRPZsBV-qJswWDfwMYjidEDsRzR-r5TG0or1--k599=Cju+tw@mail.gmail.com>
Date: Wed, 30 May 2012 06:20:55 +0800
Message-Id: <20120529222055.0F4B23E07FB@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012 12:41:24 +0200, Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com> wrote:
> >> --- linux-3.2.16.orig/include/linux/irqdesc.h 2012-04-23
> >> 00:31:32.000000000 +0200
> >
> > Your mailer wraps lines; see Documentation/email-clients.txt.
> 
> Great. I only have gmail accounts. Documentation states it won't work
> with gmail. Any suggestions ?

Only the web interface is the problem.  You need to send your mail
using SMTP from a mail client.  The best way is to use the git
send-email tool.  I've not tried the following, but it looks like it
should work (I personally use a postfix spooler so I can queue up sent
mail while I'm offline, but that's more complex to set up):

http://morefedora.blogspot.com/2009/02/configuring-git-send-email-to-use-gmail.html

g.

