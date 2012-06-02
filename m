Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358Ab2FBMN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 08:13:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60443 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937Ab2FBMNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 08:13:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120602115655.GA12001@kroah.com>
References: <1337518508-23282-1-git-send-email-morbidrsa@googlemail.com>
	<CAGH8bx63_fBKnD3P6c3gn9odAjj4bXzVrpsOyE6grHT7hOYy-g@mail.gmail.com>
	<20120602115655.GA12001@kroah.com>
Date: Sat, 2 Jun 2012 14:13:24 +0200
Message-ID: <CAGH8bx5naaYvVNbNsLrq5A0dhXfrqh93a5ApEEKhyjvTi11Uvg@mail.gmail.com>
Subject: Re: [PATCH] drivers/staging/line6/variax.c: Change some
 strict_strtoul() calls
From: morbid-rsa <morbidrsa@googlemail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stefanha@gmail.com, andor.daam@googlemail.com, grabner@icg.tugraz.at,
        jj@chaosbits.net, thomas@m3y3r.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 2, 2012 at 1:56 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Jun 02, 2012 at 01:36:10PM +0200, morbid-rsa wrote:
>> Just wanted to ask about the status of this patch.
>>
>> On Sun, May 20, 2012 at 2:55 PM, Johannes Thumshirn
>> <morbidrsa@googlemail.com> wrote:
>> > Changed strict_strtoul() calls which do not result in a need to change
>> > interfaces of called functions.
>> >
>> > Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
>> > ---
>> >  drivers/staging/line6/variax.c |    8 ++++----
>> >  1 files changed, 4 insertions(+), 4 deletions(-)
>
> As this came in after the merge window closed for patches, I have to
> hold on to it until 3.5-rc1 comes out.  It's in my queue and not lost,
> don't worry.
>
> thanks for your patience,
>
> greg k-h

Oh ok, thanks for the fast answer.

Johannes
