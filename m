Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1LGGbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:31:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37623 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1LGGbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:31:20 -0500
Date: Wed, 7 Dec 2011 10:31:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
Message-ID: <20111207063115.GB20459@moon>
References: <20111205182010.GV14515@moon>
 <20111206140833.3b43fbeb.akpm@linux-foundation.org>
 <20111206221515.GP29781@moon>
 <20111206225315.GA20459@moon>
 <CAGXu5j+RENTABtLqq4Vv4XOXStfw6rqpaKrtUMwFAZ5VCEwr8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5j+RENTABtLqq4Vv4XOXStfw6rqpaKrtUMwFAZ5VCEwr8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 03:22:03PM -0800, Kees Cook wrote:
> On Tue, Dec 6, 2011 at 2:53 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > +  start_data    address above which program data is placed
> > +  end_data      address above which program data is placed
> 
> Should the latter be "address below which program data is placed"?
> 

Yeah, copy-paste typo, thanks!

	Cyrill
