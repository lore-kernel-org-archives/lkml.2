Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab1ETNbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:31:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851Ab1ETNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=aRwf9QhILGtevzfBOfTCzHeSrZOPWlSHt7ozBCrHWnxp0auNMsJlX4KKoTx7zWAGB0
         7WEqtbLXxoLHwy7BqwUGkJxSeSPnTO80DdoEnTWh7eWvub43rH6b0cegcD4F8JOTk+zh
         8ji1jEqasbQVsI9sx+VIGGPM7qTJUquzGknkU=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-multitouch: Add support for Lumio panels
References: <1305725244-5327-1-git-send-email-benjamin.tissoires@enac.fr>
	<87boyyo0gr.fsf@macbook.be.48ers.dk>
	<BANLkTikPXHswWQqQHqd8fegotqoZPLErsQ@mail.gmail.com>
	<87mxihd6kh.fsf@macbook.be.48ers.dk>
	<BANLkTi=nyaVBhKB6bKLCqtykjMAaKfEt9A@mail.gmail.com>
Date: Fri, 20 May 2011 15:31:43 +0200
In-Reply-To: <BANLkTi=nyaVBhKB6bKLCqtykjMAaKfEt9A@mail.gmail.com> (Benjamin
	Tissoires's message of "Fri, 20 May 2011 15:12:50 +0200")
Message-ID: <87ipt533cw.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Benjamin" == Benjamin Tissoires <benjamin.tissoires@enac.fr> writes:

 Benjamin> Hi Peter,

 Benjamin> I'll see with the device maker if your device should work in
 Benjamin> multitouch. Your new evtest does not report enough multitouch
 Benjamin> things, which is weird.

Thanks. I haven't tried myself, but I believe it works with multitouch
in Win7.

-- 
Bye, Peter Korsgaard
