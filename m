Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab1IPDAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 23:00:51 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:58626 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1IPDAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 23:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <1316099130.7561.YahooMailNeo@web114311.mail.gq1.yahoo.com>
References: <1316099130.7561.YahooMailNeo@web114311.mail.gq1.yahoo.com>
Date: Fri, 16 Sep 2011 11:00:42 +0800
Message-ID: <CAF1ivSaGJX54Nn7t7JnBZV-42t9665wzt-pf_30OERAuAE2=UQ@mail.gmail.com>
Subject: Re: general protection fault: 0000 -#1] SMP
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Justin Mattock <justinmattock@yahoo.com>
Cc: "refpolicy@oss.tresys.com" <refpolicy@oss1.tresys.com>,
        "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 11:05 PM, Justin Mattock
<justinmattock@yahoo.com> wrote:
>
>
> using the current mainline, I woke the machine up from suspend, then started to relabel the filesystem, using the stable release policy(MCS). then this showed up:
> I only have photos of the crash, due to a total system lock
> http://www.flickr.com/photos/44066293@N08/6149812345/in/photostream
> http://www.flickr.com/photos/44066293@N08/6149811913/in/photostream

Is this a regression? Does it happen for 3.0 kernel?

It crashed at __list_del_entry.
Could you enable CONFIG_DEBUG_LIST=y to get more info?

Lin Ming

>
> Note: I subscribed using my yahoo accnt due to changing, but for some reason, am not able to complete the process
> (will try again to see).
>
> if you need more info let me know(I will try and recreate this, and possibly due a bisect on the kernel and/or pull refpolicy git to see)
>
> Justin P. Mattock
>
> --
