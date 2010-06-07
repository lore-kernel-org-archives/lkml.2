Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0FGSCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:02:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53504 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab0FGSCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QthSxoGsWrT1BqeC3vfqLQezLBJoaZuUU5ZKVGg1Q6toYlhJJ/J7GzHY9OITmX8771
         9iDnHSDgWe8BWQsdDjj23rQ79bahOoUhuZzHPdOeLtBsMxDc2y54LZzkUUnUaw48Yd2P
         4HtphGLWGSvoAUu4DJXiEE2ZCYef3CGH3rqvo=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: linux-kernel@vger.kernel.org,
       Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: Re: [PATCH] kconfig qconf: port to QT4
Date: Mon, 7 Jun 2010 14:01:56 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
References: <1275846668-17863-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de> <4C0CE9FC.60905@suse.cz> <201006071912.54313.alexander.stein@informatik.tu-chemnitz.de>
In-Reply-To: <201006071912.54313.alexander.stein@informatik.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006071401.56867.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 June 2010, Alexander Stein wrote:
>Hello Michal,
>
>Am Montag 07 Juni 2010, 14:45:48 schrieb Michal Marek:
>> I've only very little experience with Qt 3 or 4. The patch basically
>> changes most QSomeClass to Q3SomeClass, which is the Qt3-compatible
>> wrapper around QSomeClass. Now is it possible to still support Qt3? E.g.
>> have a header file that #defines Q3SomeClass back to QSomeClass and does
>> similar with the Qt headers, would that be possible? I know that Qt4 has
>> be there for five years already, but if the cost of keeping support for
>> old userspace is not too hight, I would try it.
>
>I never thought about qt3 compatibility but It seems to me that renaming
> the qt3 compat classes and revert the header file name changes should
> suffice to compile against qt3 again. But then somebody else has to do
> the makefile magic to support both versions. Also which version should be
> prefered if both are available?
>
>> BTW, after applying your patch, make xconfig starts ok, but clicking in
>> the main menu does nothing, and if I close the close button, it does not
>> exit, but stops reacting to any input (but it still handles window
>> resize). The qt3 version would display the "Save changes?" dialog here.
>
>I can click in the window around and closing the window using the X button
>asks me about saving the changes. Which QT version do you use actually?
>
>Best regards
>Alexander

Re-enabling kconfig for gt4 only distros like mdv, would be hugely 
appreciated Alexander.  I have never been comfy with menuconfig, which is 
forced now.

So thanks for anything you can do about making both gconfig and kconfig 
work, as neither does on mdv-2010-x86-64.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Whoever tells a lie cannot be pure in heart -- and only the pure in heart
can make a good soup.
		-- Ludwig Van Beethoven
