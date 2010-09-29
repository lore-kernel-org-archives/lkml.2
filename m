Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0I2BNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:13:36 -0400
Received: from kroah.org ([198.145.64.141]:53919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab0I2BNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:13:33 -0400
Date: Tue, 28 Sep 2010 18:14:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.35.7
Message-ID: <20100929011419.GB25515@kroah.com>
References: <20100929011355.GA25515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929011355.GA25515@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 78f9271..4c397f4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = .6
-NAME = Sheep on Meth
+EXTRAVERSION = .7
+NAME = Yokohama
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 14ed358..6830a4d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -935,7 +935,7 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
-static struct irq_chip en_percpu_chip __read_mostly = {
+static struct irq_chip xen_percpu_chip __read_mostly = {
 	.name		= "xen-percpu",
 
 	.disable	= disable_dynirq,
