Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0KKT4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:56:22 -0500
Received: from smtp104-mob.biz.mail.gq1.yahoo.com ([98.136.185.195]:40959 "HELO
	smtp104-mob.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755366Ab0KKT4U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:56:20 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 14:56:20 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:References:Mime-Version:In-Reply-To:X-Apple-Yahoo-Original-Message-Folder:Content-Type:Content-Transfer-Encoding:Message-Id:Cc:X-Mailer:From:X-Apple-Yahoo-Replied-Msgid:Subject:Date:To;
  b=Y87cNUMlAq0WEeGO6bvrhGeI6vJ8hB9vA7ZIhZakj2XR7VqEZdTgiJCzOwnr/D9gNfO0WaDE2aBDHnXVflTqk9nBqrKIhRWtjnVNcb/s4U1tevcaCmfeJhEFnGGLWsDeNJHY2f0bnkUYhiAFCMut8O5vooc+ybCbOOtxJDkhQrU=  ;
X-Yahoo-SMTP: Jr5mEQOswBBUeQ6oSnePwwxoZ1M-
X-YMail-OSG: lWJ4TmoVM1mGj9HDn.2mSgo5jngPUkWUcoYvSA.IKl2cU6o
 NUvg_vPasIklCeKQEJz4.W24vPzNQLnaQrOkwf9HgQq1VpYvtIktRx47W1yp
 c0RKdVO6DvhHRLgyVenVZFYiKsv2tCjtX6SiagYBRQmZK8AkorDgDkTPp9qt
 tCgVAXBQss23NHU0ZeLlt0Oauf_t7fWIvd3GV8GhdboxYmZvc2US2704IAgy
 zBGZ9jk8xm69RvPA5aRBRRtHyXKHJ1PI3wKhiArAVYDrUYnWqMCS3AvKFedA
 qvTlNXHolRUjs_sU2U8pUQW_eNExbX79pgZnj.1c0KwZBgLQUi0DgWA--
X-Yahoo-Newman-Property: ymail-3
References: <20101111174322.GB20296@one-eyed-alien.net> <673670.8195.qm@web31801.mail.mud.yahoo.com> <20101111184946.GC20296@one-eyed-alien.net> <20101111191110.GA12308@kroah.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
In-Reply-To: <20101111191110.GA12308@kroah.com>
X-Apple-Yahoo-Original-Message-Folder: Inbox
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <E61DA540-D3C6-472F-8680-DA57ECBEC76A@yahoo.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8B117)
From: Luben Tuikov <ltuikov@yahoo.com>
X-Apple-Yahoo-Replied-Msgid: 1_6086636_AEHPjkQAAOixTNxDaQHiXCsOMnc
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 11:50:19 -0800
To: Greg KH <greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 11, 2010, at 11:11, Greg KH <greg@kroah.com> wrote:

> On Thu, Nov 11, 2010 at 10:49:46AM -0800, Matthew Dharm wrote:
>> On Thu, Nov 11, 2010 at 10:27:11AM -0800, Luben Tuikov wrote:
>>> The patch uses SCSI functions to abstract the sense information irrespective of the type of format of sense data.
>> 
>> Looks reasonable.  The underlying SCSI functions seem to all have the tests
>> to distinguish between sense format types.  Let's just hope there are no
>> devices out there which can confuse those tests, or we'll be buried in
>> regressions.
>> 
>> ACKed-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
> 
> Luben, can you resend me the original patch with Matthew's ack on it?  I
> no longer have it in my mboxes.
> 

No prob. 

> thanks,
> 
> greg k-h
