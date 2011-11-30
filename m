Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1K3IQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:16:28 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:55143 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1K3IQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:16:26 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Nov 2011 03:16:26 EST
Subject: Re: [PATCH 0/3] last merge in hid-multitouch
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <20111130001956.GA3276@polaris.bitmath.org>
Date: Wed, 30 Nov 2011 09:10:07 +0100
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <226E0B80-B664-422B-8075-7D817932CABF@enac.fr>
References: <1322568792-4432-1-git-send-email-benjamin.tissoires@enac.fr> <20111130001956.GA3276@polaris.bitmath.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, granted. Tonight our research group goes together to a restaurant, so it will be easily resolved :-)

Cheers,

St.



Le 30 nov. 2011 à 01:19, Henrik Rydberg a écrit :

>> Here are some multitouch updates.
>> The first one is the last merge to handle all win7 compliant multitouch
>> devices in hid-multitouch (finally, we've got it!).
>> The others are the migration to input_register to allocate items before
>> the input is ready, and another VID/PID.
> 
> I believe Stephane owes you a beer now. ;-)
> 
>    Acked-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Thanks, Benjamin.
> 
> Henrik

