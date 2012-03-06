Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2CFSQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:16:45 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47075 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab2CFSQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:16:44 -0500
Date: Tue, 6 Mar 2012 10:16:17 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120306181617.GA9374@count0.beaverton.ibm.com>
References: <20120305152826.GA12419@redhat.com>
 <20120305211436.GM7666@count0.beaverton.ibm.com>
 <20120306162814.GA12836@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306162814.GA12836@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030618-4242-0000-0000-000000F9469B
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

Sure:

Acked-by: Matt Helsley <matthltc@us.ibm.com>

Cheers,
	-Matt Helsley

