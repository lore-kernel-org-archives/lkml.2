Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0IWQN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:13:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62533 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0IWQN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UagT8ajOEsDGUP1Ib/eMZMxb28Ccgghf2oznDwwYVE9E5NUS3NanUc/t/dqHtD6zPE
         m4YvcKWPOO2sNmLzTV8hK/eA8YLI4qgE5jiYyRSmwzm/xASUwk/u6/q2qjtt3B9G/MEA
         lYNCeOVwHa8fzC14jKCL9U0l8me0pBrknjDVs=
MIME-Version: 1.0
In-Reply-To: <20100922120219.407ec023@debxo>
References: <20100922164402.A72D49D401B@zog.reactivated.net>
	<20100922120219.407ec023@debxo>
Date: Thu, 23 Sep 2010 17:13:41 +0100
X-Google-Sender-Auth: O22QPLNh4cDRO0fx_AKFkxZxuz0
Message-ID: <AANLkTimjU7yqorpQW6gtK-H2jj8VTEMukDCSqu7oQRCn@mail.gmail.com>
Subject: Re: [PATCH 2/3] PCI: OLPC configuration cleanup
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: tglx@linutronix.de, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2010 20:02, Andres Salomon <dilinger@queued.net> wrote:
> On Wed, 22 Sep 2010 17:44:02 +0100 (BST)
> Daniel Drake <dsd@laptop.org> wrote:
>
>> An OLPC system isn't usable without PCI, so we can simplify the
>> configuration here.
>
> Hm, I think I'm opposed to tying it into CONFIG_OLPC like that.  Future
> plans call for an ARM-based OLPC which will presumably not have a PCI
> bus.

Good point. We should save cleanups in this area until it's clearer
how the ARM-based XO-1.75 will fit into everything.

> ..However, I'm also failing to come up w/ a good alternative right
> now.

It's only a cleanup, so can be dropped without worry.

I'll send the important bit (board revision check for XO-1 special pci
config) as a separate patch.
This patch can be dropped.

Daniel
