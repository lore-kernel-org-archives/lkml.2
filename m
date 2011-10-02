Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1JBLwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 07:52:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42629 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1JBLwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 07:52:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Date: Sun, 2 Oct 2011 13:54:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com>
In-Reply-To: <4E87B885.50005@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110021354.57995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 02, 2011, H. Peter Anvin wrote:
> On 10/01/2011 06:04 PM, Rafael J. Wysocki wrote:
> > 
> > OK, I'm taking this as "5 years is fine by us". :-)
> > 
> > And the recommended procedure for rotating keys seems to be (1) generate
> > a new key and (2) make as many people as you can sign it before the old
> > one expires, right?
> > 
> 
> (3) revoke the old key with a status code of "no longer in use", or just
> let it expire.
> 
> >> Some people have decided to opt for an unlimited key, but that
> >> *requires* that you have a way to revoke the old key, which is why we
> >> are considering a key revocation escrow service.
> > 
> > That service will be necessary anyway in case some keys are lost or
> > compromised.
> > 
> > I wonder what the procedure of restoring kernel.org access in case one
> > has lost keys is supposed to be?
> 
> Get a new key and get it re-signed.

Hmm.  That doesn't seem very practical if someone doesn't live close
to any other core kernel developers.

What number of signatures on the key will be regarded as sufficient?

> We can work out specific details at KS.

Well, the KS is going to be busy time this year I suppose. :-)

What about people who haven't been invited to the KS?

Rafael
