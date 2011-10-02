Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1JBXDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 19:03:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46950 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1JBXDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 19:03:01 -0400
MIME-Version: 1.0
In-Reply-To: <20111001140519.GA26662@kroah.com>
References: <4E8655CD.90107@zytor.com> <20111001140519.GA26662@kroah.com>
From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date: Mon, 3 Oct 2011 08:02:39 +0900
Message-ID: <CABMQnVLd3VpNntgUEiCYrjCAVt4dAtO2H5C3iAsfEv0kA3URrw@mail.gmail.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/10/1 Greg KH <greg@kroah.com>:
> On Fri, Sep 30, 2011 at 04:50:37PM -0700, H. Peter Anvin wrote:
>> 2. Create a new PGP/GPG key, and also generate a key revocation
>>    certificate (but don't import it anywhere -- save it for the
>>    future) for your new key.  In the near future we are considering
>>    setting up an escrow service for key revocation certificates.
>>
>>    I recommend using a 4096-bit RSA key.  Given how fast computers are
>>    these days, there is no reason to use a shorter key.  DSA keys
>>    should be considered obsolete; substantial weaknesses have been
>>    found in DSA.
>>
>>    $ gpg --gen-key
>>    $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke
>
> I would recommend a physical access device for your new gpg key that you
> create.  I've heard good things about this USB device:
>        http://www.crypto-stick.org/
> and am trying to have a bunch of them at the Kernel Summit this year to
> hand out to people if they want one.
>
> There are also lots of other smart-card form-factor devices that can be
> used to store GPG keys.  Some places to purchase these can be found at
> links from the above site.

Maybe you know , there are the following projects, too.
 http://www.fsij.org/gnuk/

Nobuhiro
-- 
Nobuhiro Iwamatsu
   iwamatsu at {nigauri.org / debian.org}
   GPG ID: 40AD1FA6
