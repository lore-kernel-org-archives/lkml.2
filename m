Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2JIWZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:25:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:51325 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab2JIWZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:25:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: katabami <katabami@lavabit.com>
Subject: Re: PROBLEM: Performance drop
Date: Tue, 9 Oct 2012 22:19:55 +0000 (UTC)
Message-ID: <loom.20121010T001922-860@post.gmane.org>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com> <20120524123116.GA4048@alberich.amd.com> <CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com> <20120529140940.GA10421@alberich.amd.com> <CA+fU7qdKYA3KJr3xET_evO_1ztSKh0K0csn5Coro7Mkv_my+eg@mail.gmail.com> <20120530124333.GA3008@alberich.amd.com> <CALyZvKxcdNWMHEGwgdO=sGTTs9sZYerYXcQEyqFwixKzzz3giA@mail.gmail.com> <20120711220643.GD10930@kroah.com> <CALyZvKwDoOPESJPHy5zBviVBuxT92eNGGCJrfd+XBdmya=uQEA@mail.gmail.com> <20120927173456.GA21025@kroah.com> <20120927174824.GD8759@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 123.222.34.33 (mozilla/4.0 (compatible; msie 6.0; windows 98; ypc 3.0.2; yplus 4.4.01d))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, just for recording. Bug 43284[1] is the duplicate of this bug report. It
stops by reporting the "bad" commit, 9bcb8118965ab4631a65ee0726e6518f75cda6c5.

[1]https://bugzilla.kernel.org/show_bug.cgi?id=43284


