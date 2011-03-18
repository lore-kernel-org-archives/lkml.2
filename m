Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab1CRVUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:20:20 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:51490 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757444Ab1CRVUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:20:15 -0400
Message-ID: <4D83CB7C.8040903@keymile.com>
Date: Fri, 18 Mar 2011 22:15:40 +0100
From: Stefan Bigler <stefan.bigler@keymile.com>
Reply-To: stefan.bigler@keymile.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
References: <4D8121F6.9060600@keymile.com><20110317000408.GA18911@kroah.com><4D8389EC.5030704@keymile.com> <20110318180718.6d019c71@lxorguk.ukuu.org.uk>
In-Reply-To: <20110318180718.6d019c71@lxorguk.ukuu.org.uk>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2011 21:15:40.0623 (UTC) FILETIME=[A25DF5F0:01CBE5B1]
X-ESAFE-STATUS: Mail allowed
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In essence if you get a value from receive_room it's a guarantee you may
> send that many bytes, it is not a precise instantaneous perfect answer to
> the question "exactly what number of bytes could fit at this precise
> moment".
>
Hi

I have no problem with having more space available than guarantied by
the value of receive_room. But what I see is that the value can be less!
Data will be lost.
My test showed:
  data to queue=201
  receive_room (guarantied space) =287
  real space in queue =0
In the last mail I attached the code for printing, the read_lock was only
added to show a constistant view of all current values.

Stefan
