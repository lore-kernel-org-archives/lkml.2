Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838Ab0KQHV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:21:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53081 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0KQHV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sXmAhAmkoAJ7b/+p+CLBVlyIxgChgT0ZGIFvJyp0WhM6oTa7ZB7D+pzcym2WohUh/I
         MpfFF+L2ebqjQJqseKin0VlIZSRfBJbo/3452HzNsh+jV2HU5deW4K/pX9PFYsVVnyu1
         1BxmPyQHxjmhGG8NJsxI545OgRQsrkRRchPKo=
Date: Tue, 16 Nov 2010 23:21:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr, spbnick@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
Message-ID: <20101117072117.GC7046@core.coreip.homeip.net>
References: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
 <alpine.LNX.2.00.1011151557510.7420@pobox.suse.cz>
 <AANLkTikKTLpzafaE9oxRz1f_ZE9zv1eL6K8aAkYmR+TB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKTLpzafaE9oxRz1f_ZE9zv1eL6K8aAkYmR+TB@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:28:19PM -0500, Tracey Dent wrote:
> On 11/15/10, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Sun, 7 Nov 2010, Tracey Dent wrote:
> >
> >> Changed Makefile to use <modules>-y instead of <modules>-objs because
> >> -objs is deprecated and should now be switched. According to
> >> (documentation/kbuild/makefiles.txt).
> >
> > Actually, where exactly does this file document it?
> >
> 
> It documents how it should be done in the section entitled --- 3.7
> Compilation flags (which starts on line 284).
> 

Actually the only reference I could find is in 3.3:

        If a kernel module is built from several source files, you specify
        that you want to build a module in the same way as above; however,
        kbuild needs to know which object files you want to build your
        module from, so you have to tell it by setting a $(<module_name>-y)
        variable.

See commit 4f8272802739f5c6ce6b0a548810a181d2f1b652 for reasoning behind
the change.

Thanks.

-- 
Dmitry
