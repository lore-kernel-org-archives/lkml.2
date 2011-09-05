Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1IEJo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:44:58 -0400
Received: from mailgw01.dd24.net ([193.46.215.41]:46712 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1IEJov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:44:51 -0400
MIME-Version: 1.0
Date: Mon, 05 Sep 2011 09:42:01 +0000
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        <linux-kernel@vger.kernel.org>
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
In-Reply-To: <20110905091918.GC2221@redhat.com>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net> <20110902233806.GA22157@elie> <20110905091918.GC2221@redhat.com>
Message-ID: <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 11:19:18 +0200, Stanislaw Gruszka <sgruszka@redhat.com>
wrote:
> this look like firmware hang. This happen just after module load, that's
> good news, because it allow to log relative small amount debug messages
> to see what possibly driver do wrong to crash firmware.
Note, that the effects of - usually but not always - frozen system while
the errors are printed (sometimes keyboard input seems still be possible
during that) ... happen over and over again... say about every  10 minutes
or so.
Not just the first time the modules is loaded.
Is the firmware loaded over and over again?


> Please configure syslog to log kernel debug messages.
Will mail it later.


Cheers,
Chris.
