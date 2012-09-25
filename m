Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2IYSAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:00:33 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37619 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab2IYSAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:00:32 -0400
Date: Tue, 25 Sep 2012 11:00:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: ktest.pl always returns 0?
Message-ID: <20120925180028.GA22896@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I'm trying to use ktest to do build tests of the stable patch series to
verify I didn't mess anything up, but I'm finding that ktest always
returns 0 when finished, no matter if the build test was successful or
failed.

Is this right?  Is there some other way to determine if ktest fails
other than greping the output log?

Oh, and any hints on kicking off a ktest process on a remote machine in
a "simple" way?  I'm just using ssh to copy over a script that runs
there, wrapping ktest.pl up with other stuff, I didn't miss the fact
that ktest itself can run remotely already, did I?

thanks,

greg k-h
