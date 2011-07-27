Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1G0Mnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:43:47 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:54943 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1G0Mnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:43:45 -0400
Subject: Re: [PATCH 2/3] hid-multitouch: Filter collections by application  usage.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <CAN+gG=FAFX-N-3FpAmgkE+im4oT9h657Rk9h3=-17sCBwVx35A@mail.gmail.com>
Date: Wed, 27 Jul 2011 14:43:42 +0200
Cc: jeffbrown@android.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, Jeff Brown <jeffbrown@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EF6EC882-8649-44B3-97A2-3E69D0D4DCAA@enac.fr>
References: <1311545261-34067-1-git-send-email-jeffbrown@android.com><131154 5261-34067-2-git-send-email-jeffbrown@android.com><13989665-31A9-4C70-B578- 5559987CC9F5@enac.fr> <CAN+gG=FAFX-N-3FpAmgkE+im4oT9h657Rk9h3=-17sCBwVx35A@mail.gmail.com>
To: benjamin.tissoires@gmail.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 25 juil. 2011 à 11:29, benjamin.tissoires@gmail.com a écrit :

> 
> I checked (with some greps) the reports we have, and it seems that all
> the device we know provide this application. So it should be safe, but
> I'm not able to test it.
> Stéphane, if you have the time to test it on our lab's devices that
> would be great.

We checked with Stantum and Lumio panels, it works fine. Added to Benjamin's check in our database of report descriptors, it gives fairly good confidence that the change is innocuous (and actually beneficial).

St.


