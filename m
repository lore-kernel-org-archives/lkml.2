Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1EXLiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:38:51 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46487 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1EXLiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=Ejhj4z4CON/WUnAPC6PcK6bTcNLGbFcpFPe8eG3MVntFla0CG6+WdqGkDccmGtOHQl
         ezwSxgdAiePdIrVrSJjEQJEVcxEIb6aZjXAe2lHy3BG2TXZXFwsC6985f9SqcdUcB5NX
         VL6xOBGfLUAu2NiFIyLHAG7ch6r+SEbUAoPkU=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: =?utf-8?Q?St=C3=A9phane?= Chatty <chatty@enac.fr>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        USB list <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-multitouch: Add support for Lumio panels
References: <1305725244-5327-1-git-send-email-benjamin.tissoires@enac.fr>
	<87boyyo0gr.fsf@macbook.be.48ers.dk>
	<BANLkTikPXHswWQqQHqd8fegotqoZPLErsQ@mail.gmail.com>
	<87mxihd6kh.fsf@macbook.be.48ers.dk>
	<BANLkTi=nyaVBhKB6bKLCqtykjMAaKfEt9A@mail.gmail.com>
	<87ipt533cw.fsf@macbook.be.48ers.dk>
	<17A85239-A316-43B7-B46C-0AD33B0D92C1@enac.fr>
Date: Tue, 24 May 2011 13:38:44 +0200
In-Reply-To: <17A85239-A316-43B7-B46C-0AD33B0D92C1@enac.fr> (=?utf-8?Q?=22?=
 =?utf-8?Q?St=C3=A9phane?=
	Chatty"'s message of "Tue, 24 May 2011 11:05:24 +0200")
Message-ID: <874o4k9vln.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stéphane" == Stéphane Chatty <chatty@enac.fr> writes:

Hi,

 Stéphane> Benjamin and I have been in touch with the Lumio people about
 Stéphane> this device and their reply is "old firmware, not supported
 Stéphane> anymore". Peter, is there a way to upgrade your firmware?

Thanks. I've not been directly involved with this project earlier or in
communication with Lumio, so I'm not 100% sure if this controller board
is able to handle new firmware. This configuration uses 2 cameras, but
we also have another setup with 4 cameras (where multitouch has been
verified under Win7). That one uses a different controller board, and
its firmware uses product ID 6 like on your setup.

I'll try to contact Lumio to verify.

-- 
Bye, Peter Korsgaard
