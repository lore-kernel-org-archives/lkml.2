Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1FXSZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 14:25:32 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:57108 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563Ab1FXSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 14:25:30 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] PM / Runtime: Update documentation of interactions with system sleep
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <871uyljys6.fsf@ti.com>
	<201106230022.56462.rjw@sisk.pl> <201106231557.43653.rjw@sisk.pl>
Date: Fri, 24 Jun 2011 11:25:26 -0700
In-Reply-To: <201106231557.43653.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 23 Jun 2011 15:57:43 +0200")
Message-ID: <87sjqz13zd.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The documents describing the interactions between runtime PM and
> system sleep generally refer to the model in which the system sleep
> state is entered through a global firmware or hardware operation.
> As a result, some recommendations given in there are not entirely
> suitable for systems in which this is not the case.  Update the
> documentation take the existence of those systems into accout.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks good, thanks for updating this.

Reviewed-by: Kevin Hilman <khilman@ti.com>

Kevin
