Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0FGV3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:29:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab0FGV3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:29:10 -0400
Message-ID: <4C0D64A2.9020701@suse.cz>
Date: Mon, 07 Jun 2010 23:29:06 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig qconf: port to QT4
References: <1275846668-17863-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de> <4C0CE9FC.60905@suse.cz> <201006071912.54313.alexander.stein@informatik.tu-chemnitz.de>
In-Reply-To: <201006071912.54313.alexander.stein@informatik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.6.2010 19:12, Alexander Stein wrote:
> Hello Michal,
> 
> Am Montag 07 Juni 2010, 14:45:48 schrieb Michal Marek:
>> I've only very little experience with Qt 3 or 4. The patch basically
>> changes most QSomeClass to Q3SomeClass, which is the Qt3-compatible
>> wrapper around QSomeClass. Now is it possible to still support Qt3? E.g.
>> have a header file that #defines Q3SomeClass back to QSomeClass and does
>> similar with the Qt headers, would that be possible? I know that Qt4 has
>> be there for five years already, but if the cost of keeping support for
>> old userspace is not too hight, I would try it.
> 
> I never thought about qt3 compatibility but It seems to me that renaming the 
> qt3 compat classes and revert the header file name changes should suffice to 
> compile against qt3 again. But then somebody else has to do the makefile magic 
> to support both versions. Also which version should be prefered if both are 
> available?

I'd say the Qt4 version, leaving the qt3 for those who have no other
option (and then letting it bitrot once the last user installs Qt4 :-)).


>> BTW, after applying your patch, make xconfig starts ok, but clicking in
>> the main menu does nothing, and if I close the close button, it does not
>> exit, but stops reacting to any input (but it still handles window
>> resize). The qt3 version would display the "Save changes?" dialog here.
> 
> I can click in the window around and closing the window using the X button 
> asks me about saving the changes. Which QT version do you use actually?


Strange, now it works fine. I'll play with it a bit more and then I'll
tell you for sure.

Michal
