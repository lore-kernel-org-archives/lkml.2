Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab0KXOEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0KXOEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:04:09 -0500
Date: Wed, 24 Nov 2010 09:03:55 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, yinghai@kernel.org
Subject: Re: [PATCH 0/3 v2] x86: Remove old nmi_watchdog
Message-ID: <20101124140355.GB22165@redhat.com>
References: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
 <20101123214957.GD1839@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123214957.GD1839@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 12:49:57AM +0300, Cyrill Gorcunov wrote:
> On Tue, Nov 23, 2010 at 02:32:02PM -0500, Don Zickus wrote:
> > Ingo asked me to remove the old nmi_watchdog to minimize the amount of
> > code duplication we have to do for recent fixes.  All the functionality
> > needed by the old nmi watchdog should be available in perf now.
> > 
> 
>  Hi Don, if I understand correctly not many things are changed from previous
> time, some tune ups here and there, right?

Right.  Just the addition of the first patch to preserve
unknown_nmi_panic, some compiler breakage fix, and documentation stuff.

Cheers,
Don
