Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1DDNGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:06:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1DDNGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vM9NaOMLFk7oXvEcnYI65wgNOcAehd2mtSCtTfYM6nJetOaMYPBRZPGINpmmCf1YXO
         ewnQ7r1juMKiAB3SaN6sPoKZkZemWevE44zrIKhb7Bho95Q0e+QfAVftgFcZBTLBfMak
         W1GBEAABPgGm5AJEWntUOlZwHsNHF1dWpXP0A=
MIME-Version: 1.0
In-Reply-To: <4D99B60D.3030009@snafu.de>
References: <4D99B60D.3030009@snafu.de>
Date: Mon, 4 Apr 2011 21:06:00 +0800
Message-ID: <BANLkTi=mU=v_6gH_5VCwZZmiX+UoqAVf+w@mail.gmail.com>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on libusb_interrupt_transfer
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Oncaphillis <oncaphillis@snafu.de>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        libusb-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 8:14 PM, Oncaphillis <oncaphillis@snafu.de> wrote:
> Hi,
>
>  We are experiencing sporadic kernel bug messages and total
> kernel freezes on usb communication via libusb-1.0.6.

First thing first, why not try the latest release version which
is libusb-1.08?

Or better yet, try the latest git from libusb-stuge branch
which has quite some fixes post 1.08.
http://git.libusb.org/?p=libusb-stuge.git;a=summary;js=1


>  We are currently under kernel 2.6.30.10 but have seen
> it also under older and newer kernel (I think the newest was
> a 2.6.36.x).
>



-- 
Xiaofan
