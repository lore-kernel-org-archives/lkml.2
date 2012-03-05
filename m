Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab2CEOLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:11:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab2CEOLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:11:30 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 01/68] USB: cdc-acm, use tty_standard_install
Date: Mon, 5 Mar 2012 15:14:19 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
        USB list <linux-usb@vger.kernel.org>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz> <1330955575-26641-2-git-send-email-jslaby@suse.cz> <4F54C7BD.1020105@suse.cz>
In-Reply-To: <4F54C7BD.1020105@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203051514.19274.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 5. März 2012, 15:03:41 schrieb Jiri Slaby:
> Forgot to CC maintainers. Done now.
> 
> On 03/05/2012 02:51 PM, Jiri Slaby wrote:
> > This is a piece I missed the last time.
> > 
> > Do not copy the functionality all over the tree. Instead, use the
> > helper the tty layer provides us with.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Oliver Neukum <oneukum@suse.de>
