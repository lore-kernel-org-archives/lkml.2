Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1BARzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:55:00 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61499 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1BARy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:54:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EMajT7uX5USx/NuMU1ihfJVGDcqFWlqbB5duYZTS2701SFxKxRf1Bmw2m+K2d9AXA+
         Cest5k64sOwJewUyHGz3kC73Q43TXy/piduuMnptt+Zfk4bvpZdqay4Tie+NHWJGTm5d
         CFGI3K+FKINIEZMHKVbKgQg1oQsHzi8+aKe+o=
Date: Tue, 1 Feb 2011 09:54:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc3: FUSE (sshfs) hangs under load
Message-ID: <20110201175452.GB518@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After installing 2.6.38-rc3 (plus a few input patches) sshfs started to
misbehave on me under load. It starts off fine but when I try to compile
a few modules against kernel sources residing on the other box the
processes go into 'D' state and just sit there doing nothing.

2.6.37 (plus input patches) works fine. Have not tried rc1 not rc2 nor
bisecting yet.

Anyone has seen something similar?

Thanks!

-- 
Dmitry
