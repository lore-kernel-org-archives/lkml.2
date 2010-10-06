Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0JFHjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:39:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39018 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab0JFHjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sBwlVDYc3XefE+Fx8rQEKwMuACDy7/1cI+z3HQtqr75W/LtQrnfGmJlWaweBZugQw5
         YtiYG8B0cFtxh2CA0uBVEH91H2T4LCoQVxw3RXntTIaQxLRS/G713O6XXFeXIYyeoHRn
         wEH4rPt/k0wPBCmT96NapLmxYFSZrPi2dOFD0=
MIME-Version: 1.0
In-Reply-To: <4CABFB6F.2070800@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1284053081.7586.7910.camel@nimitz>
	<4CA8CE45.9040207@vflare.org>
	<20101005234300.GA14396@kroah.com>
	<4CABDF0E.3050400@vflare.org>
	<20101006023624.GA27685@kroah.com>
	<4CABFB6F.2070800@vflare.org>
Date: Wed, 6 Oct 2010 10:38:59 +0300
X-Google-Sender-Auth: yx4eOrSEhkolqP1mQxU6n2vn4ug
Message-ID: <AANLkTi=0bPudtyVzebvM0hZUB6DdDhjopB06FOww8hvt@mail.gmail.com>
Subject: Re: OOM panics with zram
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 6, 2010 at 7:30 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> Deleting it from staging would not help much. Much more helpful would
> be to sync at least the mainline and linux-next version of the driver
> so it's easier to develop against these kernel trees.  Initially, I
> thought -staging means that any reviewed change can quickly make it
> to *both* linux-next and more importantly -staging in mainline. Working/
> Testing against mainline is much smoother than against linux-next.

We can't push the patches immediately to mainline because we need to
respect the merge window. You shouldn't need to rely on linux-next for
testing, though, but work directly against Greg's staging tree. Greg,
where's the official tree at, btw? The tree at

  http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

seems empty.

                        Pekka
