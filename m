Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1GOPsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:48:37 -0400
Received: from mail.perches.com ([173.55.12.10]:4013 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1GOPsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:48:36 -0400
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
From: Joe Perches <joe@perches.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
	 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 08:48:34 -0700
Message-ID: <1310744914.7582.36.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 12:05 +0200, Bart Van Assche wrote:
> Not that's it important, but this change makes is possible to
> eliminate the tid[] and lineno[] arrays again. Has that been
> considered ?

tid and lineno are decimal.  Not using intermediate
arrays would require awkward contortions to snprintf
them without emitting 0 in the output.


