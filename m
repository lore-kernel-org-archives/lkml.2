Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0C3GrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:47:05 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:33451 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab0C3GrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:47:03 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4/5] usb:Push BKL on open down into the drivers
Date: Tue, 30 Mar 2010 08:46:59 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
References: <201001131533.15704.oliver@neukum.org> <201003291530.37183.oliver@neukum.org> <alpine.LNX.2.00.1003291546040.24576@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003291546040.24576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003300846.59307.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. März 2010 15:46:59 schrieb Jiri Kosina:
> > it seems to me you cannot deadlock with the BKL and an rwsem,
> > as BKL will be dropped if a task blocks on the rwsem. 
> 
> Ah, right you are.
> 
> > This is not a nice feature of the BKL to use. Do you have an alternative 
> > idea?
> 
> Not right now, without introducing additional lock into USB core or 
> redesigning the hiddev node registration completely. Hmmm ...

Then you might want to add a comment so the next developer who wants to
eradicate BKL is warned.

	Regards
		Oliver
