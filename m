Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0JCTWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:22:51 -0400
Received: from n1-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.153]:44737 "HELO
	n1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754020Ab0JCTWt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:22:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 843717.66725.bm@omp118.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KEUQgLn9lFO/XKlTsCYfoUn/KZ+pBqynT3tqDdRTYtqHxHwPJMrOQacEA9iOnbIs2rtQujYqFtEW738zJM8+V+hqoT9OYI054ZNKWeLt99o2vk9yTA/fSELaQ2nKd2zdfZShe/TRAkC/td7Js02X/yqwVdjRrN7PgYPh5ysKCMs=;
Message-ID: <695950.71255.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: mbntKLUVM1mJAiO1mGsITXg1KAixWKhbwoFJqb6gG1NW9nk
 _8m84_xhHOHGoHh8ux.hjH4zVzSEMUEdBb9oEScN8ZMozxryg7Z4DLD2kJ4J
 Ke2QjKF9YwcyZDzTXd5pgz_09Mx6Y46_0rNCvrQqE0nDQuTxD0d6Wj0GH84c
 YqkuJWy.fFSlKYlNrV25g5CZjhcApkrNYtjRt6tB7iJ2TGxXNaRCxv5sIdHy
 zzB_xqVr9M1T2t6PnKUaJeSAwO8E8GjCpqi7hrT_nl_aGPh7WmREuKcJjk7l
 ztmMGboQs8wDdCgQYwvOMt7vxHNK5Vp3eL_f1IGARysB4IoArJRrbXA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sun, 3 Oct 2010 12:22:47 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC/PATCH 1/2] Add usb_endpoint_descriptor to be part of the struct usb_ep
To: tlinder <tlinder@codeaurora.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Tatyana Linder <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1010031201050.26676-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sun, 10/3/10, Alan Stern <stern@rowland.harvard.edu> wrote:

> 


> Speaking for myself only,

... and me too, for that matter.


 I don't think people should add
> their own 
> copyright notices in files to which they have not made
> substantial 
> changes.  A little code motion and a small API
> adjustment don't seem 
> like large enough changes to justify this.  Some of
> the other files in 
> this patch have even smaller changes!

It's pretty routine that very small patches
get merged without attribution, for that matter,
beyond GIT history.

- Dave

> 

