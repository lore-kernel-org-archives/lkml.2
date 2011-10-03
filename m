Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1JCJOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:14:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab1JCJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:14:32 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=wom5GMh1gUkA:10 a=GPLZHOGeRasA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=7O3H4tdZAAAA:8 a=v9BBqCx-N3AfPes4hwMA:9 a=CjuIK1q_8ugA:10 a=wSnxOa7AQRACTwhq:21 a=1KNthZk2ej3xbDHa:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Date: Mon, 3 Oct 2011 05:14:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111003091430.GA13919@home.goodmis.org>
References: <4E8655CD.90107@zytor.com>
 <20111001140519.GA26662@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001140519.GA26662@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 07:05:19AM -0700, Greg KH wrote:
> 
> I would recommend a physical access device for your new gpg key that you
> create.  I've heard good things about this USB device:
> 	http://www.crypto-stick.org/
> and am trying to have a bunch of them at the Kernel Summit this year to
> hand out to people if they want one.

Hmm, if I'm going to get one at KS, should I stop getting signed keys
now? A few of us have already started the GPG song and dance to get
signed keys over the phone (where we know each other enough to know
phone numbers and recognize voices).

But I did it all wrong. I have a 4k RSA key for both signing and
encrypting with no revoke generated and no expiration. The key is
currently on one of my machines, which I was about to move to an
encrypted usb device.

If I can get one of these devices, it sounds like I should create a new
key on it as my master key and start using subkeys as described in the
debian link that someone posted before. Then at the keysigning I would
just use the key from this device.


> 
> There are also lots of other smart-card form-factor devices that can be
> used to store GPG keys.  Some places to purchase these can be found at
> links from the above site.

I just pulled out an old GNU GPG card I had, and unfortunately it only
supports 1024 RSA keys.

-- Steve

