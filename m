Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2EYVUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:20:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65020 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2EYVUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120524185039.GA14713@kroah.com>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com>
 <20120521181558.GA7829@phenom.dumpdata.com> <CAJ75kXbJXVW6dJDzG7zDuiu=6NnTybM3m97gW507-yzzsa7yoQ@mail.gmail.com>
 <20120524185039.GA14713@kroah.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Fri, 25 May 2012 23:19:55 +0200
Message-ID: <CAJ75kXYhPNShZaPduMK2ympVFsu+kTxJfYB5RyGA6cnwfhXwMA@mail.gmail.com>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, shli@fusionio.com,
        stable@vger.kernel.org, xen-devel@lists.xensource.com,
        Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 8:50 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Now applied to the 3.3.x tree, thanks.

Thanks.

Ben, do you plan to apply it on top of the 3.2.x tree?

Regards,

-- 
William
