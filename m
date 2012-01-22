Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab2AVK3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 05:29:19 -0500
Received: from host132-213-122-188.magnalink.cz ([188.122.213.132]:49189 "EHLO
	nbgentoo.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751529Ab2AVK3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 05:29:17 -0500
Date: Sun, 22 Jan 2012 11:29:12 +0100
From: Lubos Kolouch <lubos.kolouch@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit
 cd9dde44f47501394b9f0715b6a36a92aa74c0d0
Message-ID: <20120122102912.GA2123@nbgentoo>
References: <jfe47e$5dn$1@dough.gmane.org>
 <86mx9gkjlv.fsf@sumi.keithp.com>
 <20120121184453.GA2698@nbgentoo>
 <86hazokcb7.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86hazokcb7.fsf@sumi.keithp.com>
X-Operating-System: Linux nbgentoo 3.3.0-rc1-dirty
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012, 12:53:00, Keith Packard wrote:
> On Sat, 21 Jan 2012 19:44:53 +0100, Lubos Kolouch <lubos.kolouch@gmail.com> wrote:
> 
> > dmesg after boot - http://paste.pocoo.org/show/538343/
> > dmesg after failed resume -  http://paste.pocoo.org/show/538344/
> 
> Ok, that's weird -- we're choosing a different display port link speed
> on resume than at boot time. I have a theory that intel_dp_mode_fixup is
> accidentally using the current bpp value when computing the values
> needed for the new mode, and that this value may differ between boot and
> resume.
> 
> Here's a patch to dump some debug info out to test this theory.
> 

Thanks, here you go:
dmesg after boot - http://paste.pocoo.org/show/538625/
dmesg after failed resume - http://paste.pocoo.org/show/538626/

Lubos
