Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab0G3X6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:58:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57423 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0G3X6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n/29mF2UIsF1RlkYigKtI45RJLgM+xmrnnAf+DYAAzB8al9GIVQvURJA8b1RUxxiWL
         Q+YCK8Zp31nT+ts479Ud3ZOcu10GXoDmUPDqv7rax1ohAok1FfXZ/GdeedWy8Kcs22MY
         exyaGB+sfaMLEAVQM0bRQbVULQnLKzCTwcR8A=
MIME-Version: 1.0
In-Reply-To: <842657.61658.qm@web180308.mail.gq1.yahoo.com>
References: <20100730212131.GA8787@kroah.com>
	<842657.61658.qm@web180308.mail.gq1.yahoo.com>
Date: Sat, 31 Jul 2010 07:58:19 +0800
Message-ID: <AANLkTikA8kRQyR6=rfSVTAjBvOauXVVRYuVVz+bVnLVc@mail.gmail.com>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some 
	gadgets
From: Xiaofan Chen <xiaofanc@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>,
        =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 6:01 AM, David Brownell <david-b@pacbell.net> wrote:
>> Or does Windows really care about the vid/pid for
>> a class device somehow?
>
> My understanding is that it does, since it really
> doesn't have a good concept of "class" being the
> generic thing.  INF files embed VIDS/PIDS even
> for drivers implementing class specs.  MSFT was
> being stupid again...
>

It depends. For Mass Storage device and HID device,
no INF file is needed. So the VID/PID really does not
matter for them. For CDC-ACM or USB RNDIS,
an INF is needed.


-- 
Xiaofan
