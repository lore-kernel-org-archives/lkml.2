Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab1GXRdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:33:55 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:36966 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751432Ab1GXRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:33:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qc7Bk/bKhHJOuueUYPxn/LoYN8AeCQ/pBDt0TAIDVP4R49dkXUXQJGvMoTqN+kBTO2Xr38diE0mZDvJPe6doRJbP6zWi7zQI/ACS1+vJ9zOPSgyjqwcVRldK6lY0Mxhx;
Date: Sun, 24 Jul 2011 10:33:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Drake <dsd@laptop.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: OLPC power management patches - merge for 3.1?
Message-Id: <20110724103346.c762a036.rdunlap@xenotime.net>
In-Reply-To: <CAGq3pz4s-Ff1dhW8TNWT0AP_2+AyTNpOroe4b7VYg254+t78_g@mail.gmail.com>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
	<20110723202032.67ebdbcc.rdunlap@xenotime.net>
	<CAGq3pz6L5VzYaGBN8Py3x9s-orAp9AoG1OMM=1p8KJ1b3TVR6Q@mail.gmail.com>
	<20110724101323.d5c9bc5a.rdunlap@xenotime.net>
	<CAGq3pz4s-Ff1dhW8TNWT0AP_2+AyTNpOroe4b7VYg254+t78_g@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 18:16:33 +0100 Daniel Drake wrote:

> On 24 July 2011 18:13, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > You can't do both of those AFAIK -- and it already depends on POWER_SUPPLY.
> > I guess you could remove "depends on POWER_SUPPLY" and add "select POWER_SUPPLY".
> > I'll see if that works.
> 
> It does indeed. I'm just wrapping up testing it and making sure that
> all the other options are fine.

Yes, my build works OK with that change.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
