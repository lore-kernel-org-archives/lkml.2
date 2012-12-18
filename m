Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2LRIG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:06:28 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:56614 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab2LRIG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:06:27 -0500
Date: Tue, 18 Dec 2012 03:06:09 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Message-ID: <1628506728.5754343.1355817969825.JavaMail.root@redhat.com>
In-Reply-To: <20121127204111.GY13292@decadent.org.uk>
Subject: Re: [PATCH 1/3] tools/hv: Fix for long file names from readdir
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.4.165]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> > This is just for sanity. The value PATH_MAX was chosen after
> > discussion
> > with K. Y. Srinivasan and Olaf Hering instead of some "magic"
> > number like
> > 256 or 512.
> 
> PATH_MAX is a magic name.

It is defined in "limits.h". I would welcome some more constructive
argumentation and critics.

> > > Using snprintf() is a good idea, but you need to check the return
> > > value and handle the truncation case somehow.
> > 
> > By using PATH_MAX sized buffer there is no need for handling the
> > truncation
> > case.
>  
> You are claiming two contradictory things: sprintf() may overrun the
> buffer, so we need the length check provided by snprintf(), but there
> is no need to check for truncation because we know the length is
> sufficient.

So what do you propose? How should it be solved?

Thank you.

Regards,
Tomas Hozza
