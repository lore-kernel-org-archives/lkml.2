Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1EMHBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:01:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48540 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab1EMHBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=k2Ln4B64anHGO2/IH+XGzztgnQFPVxL7mP7hFKuuPXykPUntEUoTU7b+uYmifHd0fT
         zXo1+JrE56nOsAxeyRWwGt71S8ih50bxTQK9xSd0d/veHinfYi9QxbskzHqbuq+tGMNU
         kZuZCLA+oE26tGk8hFbiO50GvNLE+JR7QgFEQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTikyR7ByAgxtbz-gOHspLMFo4a+vaQ@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
	<BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
	<BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
	<BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
	<BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com>
	<BANLkTikFSN-DkkPNPtv1VigCg08YoB_q2g@mail.gmail.com>
	<BANLkTi=fhsSP069WMNPN8BA=E1=1TZ6Zmw@mail.gmail.com>
	<BANLkTikyR7ByAgxtbz-gOHspLMFo4a+vaQ@mail.gmail.com>
Date: Fri, 13 May 2011 09:01:43 +0200
X-Google-Sender-Auth: zBnZpfI4c0YSMi5XxwrtiGYlkyQ
Message-ID: <BANLkTinQx+8T3Hv0T5yPEAtxtU87CcOJVw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
From: Alessio Igor Bogani <abogani@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Frysinger,

I changed the "__" in "+". Could you test this, please?
http://git.kernel.org/?p=linux/kernel/git/abogani/linux-2.6.git;a=shortlog;h=refs/heads/ksym-sorted-v6
Thanks a lot!

Ciao,
Alessio
