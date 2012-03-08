Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2CHLs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:48:28 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:33360 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab2CHLs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:48:26 -0500
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <20120308113009.GA11416@polaris.bitmath.org>
Date: Thu, 8 Mar 2012 12:48:24 +0100
Cc: Jiri Kosina <jkosina@suse.cz>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E18D154F-E02F-4DF9-8749-7F9EF92792CB@enac.fr>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com> <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>  <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>  <20120308105737.GA11201@polaris.bitmath.org>  <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr> <20120308113009.GA11416@polaris.bitmath.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 8 mars 2012 à 12:30, Henrik Rydberg a écrit :
> 
> The device-driver matching is done in the kernel, but driver (aka
> module) loading is done from userland. The crux is to be able to tell
> userland what driver to load for a certain device. In this case, it
> means giving more information to userland via the device/modalias
> construct. Or at least, that is the question. :-)
> 

Oook, I understand. The current solution used by distros is to load the hid module statically, but then we don't want to do it for every new kind of device-specific module, right? Is this your point? 

I had the feeling that the current hid code was somehow trying to be universal, thus making the point moot, and figured that we would need to reintegrate hid-multitouch into hid-core at some point. You're suggesting another, more distributed option, in which new categories of HID devices appear from time to time and are handled in new modules, right? Sounds interesting to me, I'd like to hear what the original designers of the hid module think of it.

Cheers,

St.

