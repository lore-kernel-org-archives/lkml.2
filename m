Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2GAGyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 02:54:15 -0400
Received: from ozlabs.org ([203.10.76.45]:55799 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab2GAGyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 02:54:13 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 11/11] UBI: Fastmap: Add a module parameter to enable fastmap
In-Reply-To: <1340982869-77042-12-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at> <1340982869-77042-12-git-send-email-richard@nod.at>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 01 Jul 2012 15:58:12 +0930
Message-ID: <87vci8xaf7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012 17:14:29 +0200, Richard Weinberger <richard@nod.at> wrote:
> The new parameter, ubi.fm_auto is per default 0.

...
> +module_param(fm_auto, bool, 000);

Hmm, do you really not want to see this in sysfs?  Or set it?

Cheers,
Rusty.
