Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2EIQ5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:57:19 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:36565 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab2EIQ5R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:57:17 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: David Miller <davem@davemloft.net>
Subject: Re: 3.3.x: e1000 and ixgbe hang
Date: Wed, 9 May 2012 18:57:13 +0200
User-Agent: KMail/1.9.9
References: <201205082330.12831.wolfgang.walter@stwm.de> <201205091107.11820.wolfgang.walter@stwm.de> <20120509.120546.788906941073754076.davem@davemloft.net>
In-Reply-To: <20120509.120546.788906941073754076.davem@davemloft.net>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201205091857.14406.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 9. Mai 2012 schrieben Sie:
> From: Wolfgang Walter <wolfgang.walter@stwm.de>
> Date: Wed, 9 May 2012 11:07:11 +0200
>
> > c) Dave Miller is a busy man.
>
> Therefore pinging me on crap like this makes me a more busy man, so
> don't do it, unless you want it to take even longer for me to get
> to it.

I don't understand why you are so unfriendly.

I didn't sent you any mail nor did I complain to you. If you read my first 
mail on this issue then you will see that.

But when we are at it: I think that when a bug in a stable kernel is found and 
the final fix is known it is bad practice to hord that patch till submission 
without letting stable@ know about it. I don't mean that the patch should go 
into the stable tree immediately. Of course it makes sense to wait some time 
to see if it works in Linus' tree. But why should other people waste their 
time hunting a bug already solved? And why deny people the fix?

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
