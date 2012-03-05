Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2CEQpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:45:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55982 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2CEQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:45:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.145.81 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Mon, 5 Mar 2012 20:45:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120305164547.GN7366@moon>
References: <20120302142630.GK8681@moon>
 <20120302152621.GA29744@redhat.com>
 <20120302161247.GO8681@moon>
 <20120303223333.GB26846@moon>
 <20120305142130.GA9393@redhat.com>
 <20120305142655.GC9393@redhat.com>
 <20120305144648.GA12341@moon>
 <20120305154029.GB12427@redhat.com>
 <20120305160127.GM7366@moon>
 <20120305163130.GA13744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305163130.GA13744@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:31:30PM +0100, Oleg Nesterov wrote:
> 
> User-space can be confused, yes, this is by design.
> 

OK ;)

	Cyrill
