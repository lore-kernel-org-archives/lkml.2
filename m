Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab2CaAwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:52:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab2CaAv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:51:29 -0400
Date: Fri, 30 Mar 2012 17:55:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: Phillip Lougher <plougher@redhat.com>, linux-kernel@vger.kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] sysctl: fix restrict write access to dmesg_restrict
Message-Id: <20120330175525.eaef1ece.akpm@linux-foundation.org>
In-Reply-To: <4F7646DC.8090802@nod.at>
References: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
	<4F7646DC.8090802@nod.at>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2012 01:50:52 +0200 Richard Weinberger <richard@nod.at> wrote:

> Am 31.03.2012 01:43, schrieb Phillip Lougher:
> > Commit bfdc0b4 adds code to restrict access to dmesg_restrict,
> > however, it incorrectly alters kptr_restrict rather than
> > dmesg_restrict.
> > 
> > The original patch from Richard Weinberger
> > (https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as
> > expected, and so the patch seems to have been misapplied.
> > 
> 
> Hmm, indeed.
> Any idea how this could happen, Andrew?

Presumably someone else fiddled with the file, patch(1) misapplied the
hunk and I didn't notice.

Send a fix?
