Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab0J0BY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:24:59 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42057 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab0J0BY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:24:57 -0400
X-Sasl-enc: 7ov6oV+JG7WVlhXgFPbwtyhRiEXgXejd6XBapLTuTnoq 1288142696
Date: Tue, 26 Oct 2010 23:24:50 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, Matthew Garrett <mjg@redhat.com>
Subject: Re: [ibm-acpi-devel] [PATCH 8/14]
 drivers/platform/x86/thinkpad_acpi.c: delete double assignment
Message-ID: <20101027012450.GB29299@khazad-dum.debian.net>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-9-git-send-email-julia@diku.dk>
 <20101027010908.GA29299@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027010908.GA29299@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Henrique de Moraes Holschuh wrote:
> On Tue, 26 Oct 2010, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Delete successive assignments to the same location.
> 
> There are often results of mismerges or other assorted screw ups, often
> done by the maintainer itself (e.g. me in thinkpad-acpi's case) during
> development.

Which was the case, and the error was just a duplicate line indeed and not
anything more damaging in one of my commits done a few years ago.

So,

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
