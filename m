Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2BOIu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 03:50:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab2BOIux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 03:50:53 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alexey Orishko <alexey.orishko@gmail.com>
Subject: Re: [PATCH 1/1] usb: cdc-ncm: Increase maximum allowed datagram size
Date: Wed, 15 Feb 2012 09:53:20 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, toby.gray@realvnc.com,
        oliver@neukum.name, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1329230375-25508-1-git-send-email-toby.gray@realvnc.com> <20120214.144622.678577766818888054.davem@davemloft.net> <CAL_Kpj0VSu-ByUEwTeVG5-5psab3h38bTL=ot7vYD8A+Oeb_Ug@mail.gmail.com>
In-Reply-To: <CAL_Kpj0VSu-ByUEwTeVG5-5psab3h38bTL=ot7vYD8A+Oeb_Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202150953.20341.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. Februar 2012, 23:27:29 schrieb Alexey Orishko:
> On Tue, Feb 14, 2012 at 8:46 PM, David Miller <davem@davemloft.net> wrote:
> >
> > Can a USB expert please sanity check this before I apply it?
> 
> I would recommend to change CDC_NCM_NTB_MAX_SIZE_TX(RX) to 32K and
> simply set MAX_DATAGRAM_SIZE to 16K

Have you tried that under severe memory presssure?

	Regards
		Oliver
