Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2I1GQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:16:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59276 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2I1GQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:16:02 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:998:22:0:c685:8ff:fe10:f3d8]
In-Reply-To: <20120927202553.GA19276@kroah.com>
References: <2372445.fuIXicT4H0@tux200s>
	<20120907011542.GA26688@kroah.com>
	<2329337.9aFzn0oRxF@tux200s>
	<CAKMK7uHqk1x4dM9ZA0usskNoArR6eTFmEtVw+_juzVq1NeYg+A@mail.gmail.com>
	<20120910135803.GB2972@herton-Z68MA-D2H-B3>
	<20120910140734.GC2972@herton-Z68MA-D2H-B3>
	<20120926234223.GC26223@kroah.com>
	<20120927185917.GC3211@herton-Z68MA-D2H-B3>
	<20120927202553.GA19276@kroah.com>
Date: Fri, 28 Sep 2012 08:16:01 +0200
X-Google-Sender-Auth: Xj8WScWV6l5FZTof3zzqnhyzdOI
Message-ID: <CAKMK7uFm7YVMeUKUj4wmCeV4myYYODrp2XFDn5O8PHmjg3_U4g@mail.gmail.com>
Subject: Re: Re: 3.4.10 i915 [GM45] regression
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:25 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> I think the conclusion looking at the bug report
>> (https://bugs.freedesktop.org/show_bug.cgi?id=54575) is
>> that the commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 should be
>> reverted on 3.4, please correct me if I'm wrong.
>
> Daniel, do you agree with this?

Yeah, seems like the sanest thing to do given the situation and lack
of any understanding what's actually going on.

/me goes back to screaming silently
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
