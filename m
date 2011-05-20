Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab1ETHbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:31:24 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:55661 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab1ETHbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:31:23 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 May 2011 03:31:23 EDT
Subject: Re: [PATCH] hid-multitouch: Add support for Lumio panels
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <BANLkTikPXHswWQqQHqd8fegotqoZPLErsQ@mail.gmail.com>
Date: Fri, 20 May 2011 09:22:35 +0200
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        USB list <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7B870F7B-46C4-4F22-A28A-05CF9F409889@enac.fr>
References: <1305725244-5327-1-git-send-email-benjamin.tissoires@enac.fr> <87boyyo0gr.fsf@macbook.be.48ers.dk> <BANLkTikPXHswWQqQHqd8fegotqoZPLErsQ@mail.gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 20 mai 2011 à 00:37, Benjamin Tissoires a écrit :

> Hi Peter,
> 
> your device presents Contact ID, Tip Switch, In Range and Confidence.
> I would say that Win 7 would treat it as a multitouch screen, so this
> might work with hid-multitouch. Please note that's the first time I
> see a report descriptor with only one touch reported for a multitouch
> screen.

Might be the same serial protocol as in capacitive eGalax panels.

St.



