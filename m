Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1ENRdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 13:33:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51742 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1ENRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 13:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OqWWlYlzJVR+jsUC55qvDKS5dT8Cq2oSLcynowpLKuLHhEVBIx+zKWQ7q+SfQMuIaB
         zoIIWRz8CI+HpFiIAjISq7dG+JAbUjUCEgEByIWXGz6E8tflVmfdGYJKWTYpgYTSn8IH
         sAL89h1Au9B4FnDHXzu3Ioa3K9c4QhjGSpsAE=
MIME-Version: 1.0
In-Reply-To: <BANLkTinQx+8T3Hv0T5yPEAtxtU87CcOJVw@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
 <BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com> <BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
 <BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com> <BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
 <BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com> <BANLkTikFSN-DkkPNPtv1VigCg08YoB_q2g@mail.gmail.com>
 <BANLkTi=fhsSP069WMNPN8BA=E1=1TZ6Zmw@mail.gmail.com> <BANLkTikyR7ByAgxtbz-gOHspLMFo4a+vaQ@mail.gmail.com>
 <BANLkTinQx+8T3Hv0T5yPEAtxtU87CcOJVw@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 14 May 2011 13:32:50 -0400
Message-ID: <BANLkTiktnQyEnNiQdTr_p=PG66rzVkr9ig@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 03:01, Alessio Igor Bogani wrote:
> I changed the "__" in "+". Could you test this, please?
> http://git.kernel.org/?p=linux/kernel/git/abogani/linux-2.6.git;a=shortlog;h=refs/heads/ksym-sorted-v6
> Thanks a lot!

seems to build & boot ok for me.  cheers.
-mike
