Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1CKWYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:24:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57641 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1CKWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=PoLECl3YxHjqjsF9KXUn68L3jm9bEPIbAqpmSpDZIDJ27+WrFkfOWnU1LDQWGdAblE
         NG88cYrdYF5sJaUaRCtZ/lm3hP/RASjkmctAkhfjHMZu9UlPIHkvGAuPAeNCjNlqzTNp
         c0o+4Nohu7/QQuyMBwus49u0ARFRIjhrviKnU=
Message-ID: <4D7AA109.8060102@linaro.org>
Date: Fri, 11 Mar 2011 22:24:09 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <Pine.LNX.4.44L0.1103111406270.1975-100000@iolanthe.rowland.org> <4D7A80A4.6040008@linaro.org> <20110311202135.GA10795@kroah.com> <4D7A8F28.4080908@linaro.org> <20110311214406.GA29582@kroah.com>
In-Reply-To: <20110311214406.GA29582@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 09:44 PM, Somebody in the thread at some point said:

> I'd have to see your patch for how you do this, but again note that USB
> device numbering is NOT deterministic in any way.  Just like PCI device
> numbering isn't.  You would have the same problem there as well if you
> were to want to do this type of thing.

Alright, I will aim to make an implementation this weekend and we can see.

-Andy
