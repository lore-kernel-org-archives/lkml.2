Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab1FJTZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab1FJTZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:25:31 -0400
Date: Fri, 10 Jun 2011 15:25:29 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jason Gerecke <Jason.Gerecke@wacom.com>
Subject: Re: [PATCH] wacom: use only one interface with DTU-2231
Message-ID: <20110610192529.GE5510@redhat.com>
References: <20110610182344.GB5510@redhat.com>
 <BANLkTinmm1i1XZ=+8AYFQAR4_-DUxQGb4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinmm1i1XZ=+8AYFQAR4_-DUxQGb4w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 12:17:51PM -0700, Ping Cheng wrote:
> On Fri, Jun 10, 2011 at 11:23 AM, Aristeu Rozanski <aris@redhat.com> wrote:
> 
> > The Wacom DTU-2231 tablet has two interfaces on its default configuration
> > and
> > both have HID class, leading to the creation of two input devices
> > instead of one. Only the first one is used, so filter out the second.
> >
> 
> Reviewed-by: Ping Cheng <pingc@wacom.com>
> 
> Thank you for the patch. You forgot to put your s-o-b though.
oops :)

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

