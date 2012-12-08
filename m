Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2LHMhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 07:37:21 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:54556 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135Ab2LHMhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 07:37:18 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av5JACo0w1BV5qjOPGdsb2JhbABEhUwjhQCzbxcDAQEBATg0gh4BAQQBJxMcIwULCAMOOBQlChqIHgrAEhSQDWEDlgSFe41C
X-IronPort-AV: E=Sophos;i="4.84,243,1355094000"; 
   d="scan'208";a="166898214"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 8 Dec 2012 13:39:35 +0100
To: Benson Leung <bleung@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Dudley Du <dudl@cypress.com>
Subject: Re: [PATCH v2 1/1] Input: add driver for Cypress APA I2C Trackpad
Message-ID: <20121208123935.GA3147@polaris.bitmath.org>
References: <1341959357-14691-1-git-send-email-bleung@chromium.org>
 <1354754899-26701-1-git-send-email-bleung@chromium.org>
 <1354754899-26701-2-git-send-email-bleung@chromium.org>
 <20121206145911.GA9882@polaris.bitmath.org>
 <CANLzEkttUr80DX1z-QfqKq8VM0G25m2bTADwU5pUBiB4HAU0Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLzEkttUr80DX1z-QfqKq8VM0G25m2bTADwU5pUBiB4HAU0Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

> I have applied your patch, but I found I still need this line in my
> driver, otherwise, there are no ABS type event supported. Should the
> core set this bit as well since it's certainly going to be dealing
> with ABS data?
> 
> __set_bit(EV_ABS, input->evbit);

Yes, that would make sense, I will look into it.

> Otherwise, it works great on my Chromebook trackpad here.

Great,
Henrik
