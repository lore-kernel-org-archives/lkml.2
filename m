Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2IYPnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:43:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53035 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2IYPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:43:50 -0400
Message-ID: <5061D12F.1000308@redhat.com>
Date: Tue, 25 Sep 2012 17:43:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, rusty@rustcorp.com.au,
        herbert@gondor.hengli.com.au, pjones@redhat.com, jwboyer@redhat.com,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: Wrong system clock vs X.509 date specifiers
References: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk> <5555.1348531649@warthog.procyon.org.uk> <21845.1348585794@warthog.procyon.org.uk> <30071.1348587320@warthog.procyon.org.uk>
In-Reply-To: <30071.1348587320@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/09/2012 17:35, David Howells ha scritto:
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>> > Generate a certificate that is valid from a few minutes before the
>> > wallclock time. It's a certificate policy question not a kernel hackery
>> > one.
> That doesn't seem to be possible with openssl req.  What would you recommend?

Disgusting, but: add an LD_PRELOAD library that returns a time well in
the past.

Paolo
