Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1JBBEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 21:04:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43863 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1JBBEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 21:04:16 -0400
Message-ID: <4E87B885.50005@zytor.com>
Date: Sat, 01 Oct 2011 18:04:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110012333.55428.rjw@sisk.pl> <4E8793B6.8030405@zytor.com> <201110020304.28288.rjw@sisk.pl>
In-Reply-To: <201110020304.28288.rjw@sisk.pl>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2011 06:04 PM, Rafael J. Wysocki wrote:
> 
> OK, I'm taking this as "5 years is fine by us". :-)
> 
> And the recommended procedure for rotating keys seems to be (1) generate
> a new key and (2) make as many people as you can sign it before the old
> one expires, right?
> 

(3) revoke the old key with a status code of "no longer in use", or just
let it expire.

>> Some people have decided to opt for an unlimited key, but that
>> *requires* that you have a way to revoke the old key, which is why we
>> are considering a key revocation escrow service.
> 
> That service will be necessary anyway in case some keys are lost or
> compromised.
> 
> I wonder what the procedure of restoring kernel.org access in case one
> has lost keys is supposed to be?

Get a new key and get it re-signed.  We can work out specific details at KS.

	-hpa

