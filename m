Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2CFQlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:41:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60199 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2CFQlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:41:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.143.151 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Tue, 6 Mar 2012 20:41:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120306164103.GI29367@moon>
References: <20120305152826.GA12419@redhat.com>
 <20120305211436.GM7666@count0.beaverton.ibm.com>
 <20120306162814.GA12836@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306162814.GA12836@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 05:28:14PM +0100, Oleg Nesterov wrote:
> On 03/05, Matt Helsley wrote:
> >
> > On Mon, Mar 05, 2012 at 04:28:26PM +0100, Oleg Nesterov wrote:
> > >
> > > Unless there was another subtle reason, "struct path *exe_path"
> > > can equally work but it looks more clear.
> >
> > PATCH 1/1 looks fine. I think Alexey Dobriyan was working on a similar
> > patch years ago.
> 
> Good, can I take the above as your Acked-by/Reviewed-by ?
> 

Yes, this would be great, so thenI  would re-make
my patch on top of a new concept.

	Cyrill
