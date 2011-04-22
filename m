Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1DVMEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:04:33 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57395 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab1DVMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:04:30 -0400
Date: Fri, 22 Apr 2011 13:04:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] signal: introduce retarget_shared_pending()
Message-ID: <20110422130427.6c275399@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134443.GB15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134443.GB15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:44:43 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> No functional changes. Move the notify-other-threads code from exit_signals()
> to the new helper, retarget_shared_pending().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
