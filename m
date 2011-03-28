Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1C1HzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:55:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:48197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1C1HzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:55:05 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [Bug #28562] [BUG] usb problems in .38-rc3+
Date: Mon, 28 Mar 2011 09:55:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Ed Tomlinson" <edt@aei.ca>,
        linux-usb@vger.kernel.org
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera> <40UNry85rJN.A.NIF.Hp5jNB@chimera> <20110327205727.3abd06b5@katamari>
In-Reply-To: <20110327205727.3abd06b5@katamari>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103280955.48254.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. März 2011, 02:57:27 schrieb Chuck Ebbert:
> On Sun, 27 Mar 2011 22:27:34 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
> > Subject		: [BUG] usb problems in .38-rc3+
> > Submitter	: Ed Tomlinson <edt@aei.ca>
> > Date		: 2011-02-05 19:17 (51 days old)
> > Message-ID	: <201102051417.58953.edt@aei.ca>
> > References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2

Have you tested with USB autosuspend disabled?

	Regards
		Oliver

