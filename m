Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2DWSiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab2DWSiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:38:18 -0400
Date: Mon, 23 Apr 2012 14:38:11 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] [media] rc: Postpone ISR registration
Message-ID: <20120423183811.GC31244@redhat.com>
References: <20120420205002.GD17452@redhat.com>
 <1335025521-7979-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335025521-7979-1-git-send-email-luis.henriques@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 05:25:21PM +0100, Luis Henriques wrote:
> An early registration of an ISR was causing a crash to several users (for
> example, with the ite-cir driver: http://bugs.launchpad.net/bugs/972723).
> The reason was that IRQs were being triggered before a driver
> initialisation was completed.
> 
> This patch fixes this by moving the invocation to request_irq() and to
> request_region() to a later stage on the driver probe function.

>From what I can tell, it looks like v3 should do the job for all affected
drivers.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

