Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab1FNVwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:52:15 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:54692 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab1FNVwN (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Tue, 14 Jun 2011 17:52:13 -0400
Message-Id: <4DF864A3020000230002E40D@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 14 Jun 2011 15:52:03 -0600
From: "Joey Lee" <jlee@novell.com>
To: <ike.pan@canonical.com>
Cc: <dmitry.torokhov@gmail.com>, <hadess@hadess.net>,
        "Gary Lin" <GLin@novell.com>, <mjg@redhat.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] ideapad: let Fn+F5 also trigger KEY_BLUETOOTH
References: <1308040109-12038-1-git-send-email-ike.pan@canonical.com>
 <1308043321.26522.4.camel@air.hadess.net>
In-Reply-To: <1308043321.26522.4.camel@air.hadess.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ike, 

於 二，2011-06-14 於 10:21 +0100，Bastien Nocera 提到：
> On Tue, 2011-06-14 at 16:28 +0800, Ike Panhc wrote:
> > The design for ideapad Fn-F5 key is not only for wifi but for all
> > radio device including wifi, bluetooth and wwan. Idealy it shall
> > acts like this:
> > 
> >     wifi on          wifi off         wifi on         wifi off
> >      bt on   ----->   bt on   ----->   bt off  ----->  bt off
> > 
> > This patch will switch wifi mode every key-push and switch
> > bluetooth mode every two key-push.
> 
> If that's what you want to achieve, then the key should be KEY_RFKILL.
> That's what the key is there for.
> 

I also agree push the wifi key logic to userland application has more
flexibility.

Highly suggest you can use urfkill daemon:
http://www.google.com.tw/search?sourceid=chrome&ie=UTF-8&q=urfkill

It support KEY_WIRELESS, KEY_BLUETOOTH and KEY_RFKILL, and you can setup
the wifi key rule on urfkill daemon. 
Please feel free send patch to Gary Lin <GLin@novell.com>, he can merge
your key rule for ideapad.


Thank's
Joey Lee


