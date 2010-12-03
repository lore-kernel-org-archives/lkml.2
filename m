Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab0LCMrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:47:32 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54671 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494Ab0LCMra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:47:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=nzDYlzhYPRG0p+6uYmeSVTegYomOeFN+BOAu0mh+LVcY4tdS26CqYcEq7QYdyVJqnh
         YNJXuscEYDmdqeLEOkMXk7qBHmOIb57A5w6JbtJ+qGcmL80H/qtQcjBCKDg/ftfJVbSC
         HilTioMBVUv2sbqdr6x9yijDmNC+fsKr3VegM=
MIME-Version: 1.0
In-Reply-To: <9BF90A6D61BF154E973D03082989295CA22B3F803A@SAFEX1MAIL3.st.com>
References: <matteo.dameno@st.com> <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
 <20101130060926.GA31838@core.coreip.homeip.net> <AANLkTikpVtq2cQVhhcsJhZwGFW74mTqo=-vVK1e50AC2@mail.gmail.com>
 <9BF90A6D61BF154E973D03082989295CA22B3F7E95@SAFEX1MAIL3.st.com>
 <4CF7F66F.70808@cam.ac.uk> <9BF90A6D61BF154E973D03082989295CA22B3F803A@SAFEX1MAIL3.st.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Fri, 3 Dec 2010 13:47:07 +0100
Message-ID: <AANLkTik9ODR4qGH0BTFMtQ=FY61tYj6bcHD5GLO3fWxY@mail.gmail.com>
Subject: Re: [PATCH] input: misc: add lps001wp_prs driver
To: Matteo DAMENO <matteo.dameno@st.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        mems applications <mems.applications@st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Carmine IASCONE <carmine.iascone@st.com>, Greg KH <gregkh@suse.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Paolo BENDISCIOLI <paolo.bendiscioli@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there was an old discussion about this

here
http://lkml.org/lkml/2010/8/30/290
and here
http://lkml.org/lkml/2010/8/30/410

But I don't know what was the final decision in the end.
Maybe this needs more discussion as I have said in the first mail.


i
