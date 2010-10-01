Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0JAU5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:57:39 -0400
Received: from kroah.org ([198.145.64.141]:44091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab0JAU5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:57:37 -0400
Date: Fri, 1 Oct 2010 13:57:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.24
Message-ID: <20101001205724.GB11271@kroah.com>
References: <20101001205709.GA11271@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001205709.GA11271@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 6a29b82..83813cc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .23
+EXTRAVERSION = .24
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index a4dc7bf..ac91a4e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -930,7 +930,7 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
-static struct irq_chip en_percpu_chip __read_mostly = {
+static struct irq_chip xen_percpu_chip __read_mostly = {
 	.name		= "xen-percpu",
 
 	.disable	= disable_dynirq,
