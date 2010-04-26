Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab0DZWF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:05:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57461 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752396Ab0DZWFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:05:25 -0400
Date: Mon, 26 Apr 2010 23:10:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joseph Krahn <joseph.krahn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: parport_pc.c and parport_serial.c need improvements
Message-ID: <20100426231045.115d9cd4@lxorguk.ukuu.org.uk>
In-Reply-To: <p2pff6de6f21004230933t6fdeb985jeca51a550e3dbc5b@mail.gmail.com>
References: <p2pff6de6f21004230933t6fdeb985jeca51a550e3dbc5b@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> parport_pc, similar to parport_serial. In any case, it would be nice
> to see more comments on why the SuperIO code is designed as it is.

I think the superIO code is more 'evolved' than 'designed'. It's
something people nailed bits onto in passing rather than structured
elegantly.

Do what you think is right IMHO.

Alan
