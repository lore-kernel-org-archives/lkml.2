Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1IEJYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:24:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1IEJYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:24:20 -0400
Date: Mon, 5 Sep 2011 11:24:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20110905092423.GD2221@redhat.com>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
 <20110902233806.GA22157@elie>
 <1315053922.6355.8.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315053922.6355.8.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Sat, Sep 03, 2011 at 02:45:22PM +0200, Christoph Anton Mitterer wrote:
> If there's any quick fix (like reverting the patch above) I'd be happy
> to test it,
No patch is available for that problem as far as I know. I requested for
verbose debug messages for now.

> ... cause I'm on a conference next week,.. and having no Wifi
> there is annyoing.
Perhaps you can downgrade kernel to 2.6.38 to make wifi works.

Stanislaw
