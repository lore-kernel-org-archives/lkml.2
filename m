Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1KNBqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:46:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63267 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1KNBqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:46:20 -0500
Date: Sun, 13 Nov 2011 19:46:15 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20111114014615.GC16508@elie.hsd1.il.comcast.net>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
 <20110902233806.GA22157@elie>
 <20110905091918.GC2221@redhat.com>
 <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
 <20110908084913.GB2195@redhat.com>
 <1321228952.3362.15.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321228952.3362.15.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Anton Mitterer wrote:

> Sorry for completely forgetting about this... (for so long)
>
> I've tried your patch now against 3.1, and it seems to not help.

Thanks.  Logs?  (If you can't get netconsole or a serial console
working, a photograph is fine.)

> Not sure whether trying with 2.6.38 helps.
> It "stopped" working within the very same kernel.

Not sure what you mean.  Are the quotation marks for emphasis, or do
you mean that when you replaced the mainboard it did not stop booting
in v2.6.38 but something else entirely?

As a reminder for forgetful people like me, the debugging patch in
question is at [1].

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/76658/focus=1189537
