Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1JRSwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:52:35 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42976 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365Ab1JRSwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:52:34 -0400
X-Sasl-enc: 3Q2pDzlroDdUksOob/TnMLm4/3SNKScJTPCmKVJFJnpY 1318963953
Date: Tue, 18 Oct 2011 11:52:18 -0700
From: Greg KH <greg@kroah.com>
To: jim.cromie@gmail.com, jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/26] dynamic_debug: add pending queries, etc (~resend)
Message-ID: <20111018185218.GA22653@kroah.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 02:33:06PM -0600, jim.cromie@gmail.com wrote:
> This is essentially a rebase, resend, with trivial changes:
> - drops scx200 - off topic
> - adds pr_cont_once tweak - remove pr_fmt
> as before, it has:
> - Doc tweaks per Randy Dunlap
> - pr_fmt_$severity, suggested by Joe Perches
> - does not change pr_fmt() default, per Joe
> 
> Rebased onto git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
> + Jason's 8-12/12 which havent made it into driver-core
> Ive not resent them here.

As stated before, I'm not going to be able to accept these until I get
Jason's ack on them.

Jason?

