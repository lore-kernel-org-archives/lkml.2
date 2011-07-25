Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1GYSrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:47:04 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:51802 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1GYSrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:47:03 -0400
Subject: Re: [PATCH 2/3] hid-multitouch: Filter collections by application  usage.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <CAMu+ixi4gpKg=LW4o2nK7NDm4r+B368qh=fSvtndKfqf204K9A@mail.gmail. com>
Date: Mon, 25 Jul 2011 20:47:00 +0200
Cc: benjamin.tissoires@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Content-Transfer-Encoding: 8BIT
Message-Id: <96E091D9-DDB9-4963-9F10-30231BF93C98@enac.fr>
References: <1311545261-34067-1-git-send-email-jeffbrown@android.com>  <CAN+gG=FAFX-N-3FpAmgkE+im4oT9h657Rk9h3=-17sCBwVx35A@mail.gmail.com>  <E25AA279-4029-40BF-9CB0-873763C53AB4@enac.fr> <CAMu+ixi4gpKg=LW4o2nK7NDm4r+B368qh=fSvtndKfqf204K9A@mail.gmail. com>
To: Jeffrey Brown <jeffbrown@android.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 25 juil. 2011 à 20:08, Jeffrey Brown a écrit :

> On Mon, Jul 25, 2011 at 6:48 AM, Stéphane Chatty <chatty@enac.fr> wrote:
>> So far it works fine on our Cypress panel. I'll keep you posted about Lumio and Stantum as soon as we have finished compiling Linux 3.0.
> 
> Actually, I'm wondering if we could merge hid-multitouch into hid-input.
> 
> Checking for an application usage of TouchScreen or TouchPad should be
> pretty unambiguous.  It ought to be possible to support most Windows 7
> compatible HID multitouch devices out of the box without needing to
> add them to any exception lists whatsoever, except for those few that
> might need quirks.


Yes, Benjamin and I have been working in this direction. We have experimental code that autodectects multitouch devices. It's not polished nor tested enough, but the number of requests for supporting new panels is a strong incentive for us to finish it :-) As far as I remember, this requires some restructuring in hid-input though.

Cheers,

St.

