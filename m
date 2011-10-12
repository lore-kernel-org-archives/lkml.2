Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1JLTLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:11:10 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:49269 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1JLTLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:11:09 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Oct 2011 15:11:08 EDT
Date: Wed, 12 Oct 2011 21:04:55 +0200
From: Nils Radtke <lkml@Think-Future.com>
To: Linux Kernel-List <linux-kernel@vger.kernel.org>
Subject: git checkout extraversion
Message-ID: <20111012190455.GC29770@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.com>
Mail-Followup-To: Nils Radtke <lkml@Think-Future.com>,
	Linux Kernel-List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Is it possible -- and if so: how? -- to checkout specific kernel extraversion?

  Example:

  git checkout -b my2.6.39.3 2.6.39.3

  This does not work as there's no such tag "2.6.39.3" (only "2.6.39").

  I temporarily did it by manually patching 2.6.39 to .3.

  ketchup didn't help (until I noticed -- browsing manually -- http is a
  redirect to https for kernel.org).

  Thanks and cheers

