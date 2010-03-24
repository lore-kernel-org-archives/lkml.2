Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0CXRKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:10:05 -0400
Received: from web94909.mail.in2.yahoo.com ([203.104.17.168]:31994 "HELO
	web94909.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753912Ab0CXRKC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:10:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jPPbLzdBZwzQx3WioYsBBWbzgKXKyUA/Mo6RAFUVlmoxsoxq3ZDVynkCUrbbNa7mcuS1tfhGHC/4ndc5rz3NTUjFVGgSznbJWpqVCs/k5EctzEXVvQizq3EWhmLOE3KFErKgE0RS+yEJahmqHxn4/hjcu4idzYSZ9R5basx/jvg=;
Message-ID: <125378.77353.qm@web94909.mail.in2.yahoo.com>
X-YMail-OSG: HFcUTG4VM1nqtscL2UOoTjkmVyHxEYaF0L0B_89MvC70TkW
 26lcD9u0n3_LZBUk0AQ0pP29MbwRQFdQ5zaqiYjPj.aNp_1YesyGqcETV.RO
 .F6NJWEroJHkyfVHYDOGj4xQtZkWpuciwR1Wj1TM42uTeiLPeGFLEdY1YdqG
 LtuquCRg9DGDMmBH2UKgPqe4VIMgTGRM84IiVz9fDopvnO2qVYLmkla39F7g
 YoHySHVvReNalSsgdwNGVvsnr2kpydmUBXFIQODoYjv7bLR0uJA2EzX_52aN
 Oua3HCey4PzcfDGNDJyT_ZcQ-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 22:39:59 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100324170345.1ba84093@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 10:33 PM
> Ok I had a brief dig
> 
> Making a driver able to say "and open me in this ldisc" is
> about ten
> lines of code to the core tty layer if that.
> 
> There is one caveat - the actual ldisc attach method for an
> ldisc attach
> isn't allowed to fail the attach. That's something we
> eventually need to
> fix anyway.
> 
> Otherwise it doesn't look too scary and it would occur when
> the user
> opened the file not when the device was created.

So as I understand the user-space application/daemon should do an open on the TTY and then do nothing ?
Somewhere down the line, the driver may do a tty_set_ldisc, and use it the way it wants to ?

Isn't there a mechanism for the tty_set_ldisc to do what _open does ?
I mean there might be plenty of devices on UART which might not need /dev/tty at all ? i.e An App need not open for a ldisc to be installed.


> 
> Alan
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
