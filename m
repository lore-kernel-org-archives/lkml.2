Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2ESSjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:39:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:3078 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756383Ab2ESSjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <87havchd14.fsf@xmission.com>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
	<87havchd14.fsf@xmission.com>
Date: Sat, 19 May 2012 11:39:14 -0700
Message-ID: <CABsxX9J+KVSbxVahg-iVsfeNDEM_H8+MrcBBejjCZFrcNCxwtA@mail.gmail.com>
Subject: Re: [PATCH] Trace event for capable().
From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:59 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Auke Kok <auke-jan.h.kok@intel.com> writes:
>
> > Add a simple trace event for capable().
> >
> > There's been a lot of discussion around capable(), and there
> > are plenty of tools to help reduce capabilities' usage from
> > userspace. A major gap however is that it's almost impossible
> > to see or verify which bits are requested from either userspace
> > or in the kernel.
> >
> > This patch adds a minimal tracer that will print out which
> > CAPs are requested and whether the request was granted.
>
> A small comment assigned from the other issues.
>
> current->pid for anything going to userspace is broken,
> and in fact current->pid should be killed on of these days.
>
> Which pid namespace is your tracer running in?

init - I currently have no need for namespaces myself at all, and, as I replied
to Serge and Eric already - I'll see if I can fis up the tracer with their
suggestions.

Auke
