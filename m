Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0DESPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:15:43 -0400
Received: from imr2.ericy.com ([198.24.6.3]:32813 "EHLO imr2.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0DESPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:15:37 -0400
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if
 CONFIG_VGA_CONSOLE is undefined
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: <guenter.roeck@ericsson.com>
To: <linux-kernel@vger.kernel.org>
CC: <hpa@zytor.com>, <penberg@cs.helsinki.fi>, <mingo@redhat.com>,
       <x86@kernel.org>, <guenter.roeck@ericsson.com>
In-Reply-To: <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>
Content-Type: text/plain
Organization: Ericsson
Date: Mon, 5 Apr 2010 11:10:29 -0700
Message-ID: <1270491029.1477.453.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 11:32 -0400, Pekka Enberg wrote:
> On Wed, Mar 31, 2010 at 4:41 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > Current early_printk code writes into VGA memory space even
> > if CONFIG_VGA_CONSOLE is undefined. This can cause problems
> > if there is no VGA device in the system, especially if the memory
> > is used by another device.
> >
> > Fix problem by redirecting output to early_serial_console
> > if CONFIG_VGA_CONSOLE is undefined.
> >
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
What will it take to get this patch into the tree ?

If there are coding style issues or some other unresolved concerns,
please let me know.

Guenter


