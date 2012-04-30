Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2D3S4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 14:56:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2D3S4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 14:56:09 -0400
Date: Mon, 30 Apr 2012 19:56:05 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] [media] rc: Postpone ISR registration
Message-ID: <20120430185605.GA11906@zeus>
References: <20120420205002.GD17452@redhat.com>
 <1335025521-7979-1-git-send-email-luis.henriques@canonical.com>
 <20120423183811.GC31244@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423183811.GC31244@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 02:38:11PM -0400, Jarod Wilson wrote:
> On Sat, Apr 21, 2012 at 05:25:21PM +0100, Luis Henriques wrote:
> > An early registration of an ISR was causing a crash to several users (for
> > example, with the ite-cir driver: http://bugs.launchpad.net/bugs/972723).
> > The reason was that IRQs were being triggered before a driver
> > initialisation was completed.
> > 
> > This patch fixes this by moving the invocation to request_irq() and to
> > request_region() to a later stage on the driver probe function.
> 
> From what I can tell, it looks like v3 should do the job for all affected
> drivers.
> 
> Acked-by: Jarod Wilson <jarod@redhat.com>

Hi Jarod,

I was wondering whether there are any news about this patch.  I've checked
linux-media tree, and it looks like it hasn't been applied.

Cheers,
--
Luis
