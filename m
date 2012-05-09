Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab2EIW7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:59:09 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:37197 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758466Ab2EIW7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:59:07 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: David Miller <davem@davemloft.net>
Subject: Re: 3.3.x: e1000 and ixgbe hang
Date: Thu, 10 May 2012 00:59:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.5-ei+6.4; KDE/4.7.4; x86_64; ; )
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201205091107.11820.wolfgang.walter@stwm.de> <201205091857.14406.wolfgang.walter@stwm.de> <20120509.154558.1469429813580317150.davem@davemloft.net>
In-Reply-To: <20120509.154558.1469429813580317150.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201205100059.04723.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, David Miller wrote:
> From: Wolfgang Walter <wolfgang.walter@stwm.de>
> Date: Wed, 9 May 2012 18:57:13 +0200
> 
> > But when we are at it: I think that when a bug in a stable kernel is
> > found and the final fix is known it is bad practice to hord that
> > patch till submission without letting stable@ know about it.
> 
> I think you have no idea what goes into vetting patches for -stable.

I can imagine that very well. I wrote and manage a bunch of larger patches 
against wine vanilla for us and to port them regularly to newer versions.

> 
> It can take me days to put together a series, and also I time my
> -stable submissions with when Linus pulls my 'net' bug fixes into his
> tree since a part of the -stable requirements is presence in Linus's
> tree.

I know.

> 
> I therefore batch, because bleeding out individual fixes one by one to
> -stable rarely, if ever, makes sense.

I understand that and as I sad it was not my intention to question that.

> 
> And another part of what goes into vetting a patch is time.  The
> longer a patch sits in a non-stable tree getting tested, the more
> likely any unwanted bugs and side effects will be caught before the
> patch goes into -stable.
> 
> And finally I am under no obligation whatsoever to post some kind of
> status report to -stable every few days saying when I'll do this or
> that.
> 

I didn't say that you should do that.

I just don't see the point why I should not send a mail to stable@. It 
documented that there is a known problem in 3.3.5, the fix for it and that you 
already aware of it and will take care to get it into stable. Nobody had 
reported that on stable@.

I mentioned your mail not to blame you but so nobody thinks I want du submit 
it directly. Everybody reading your mail I linked to could see that you wrote 
it May 1st and therefor could not be in 3.3.5.

But I think it would have been good if someone (not you) had sent a mail as 
early as 2012-04-20 to stable@ so that others could find the solution more 
easily.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
