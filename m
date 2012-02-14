Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2BNRx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:53:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33087 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab2BNRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:53:25 -0500
Date: Tue, 14 Feb 2012 09:53:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signal: give SEND_SIG_FORCED more power to beat
 SIGNAL_UNKILLABLE
Message-ID: <20120214175319.GR12117@google.com>
References: <20120210200004.GA20890@redhat.com>
 <20120210200021.GA20898@redhat.com>
 <20120210212532.GL19392@google.com>
 <20120214174528.GA23562@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214174528.GA23562@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 06:45:28PM +0100, Oleg Nesterov wrote:
> > How about the following indentation instead?  :)
> >
> > 	if (!prepare_signal(sig, t,
> > 	    from_ancestor_ns || (info == SEND_SIG_FORCED)))
> 
> Well, I am not sure this looks better, although I do not really mind.
> But since this patch is already in -mm, I think I won't send v2 ;)

Yeah, they are different but equally ugly, I suppose. :)

-- 
tejun
