Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0HXNCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:02:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52053 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0HXNCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vlCTeUVPsDLY+jZ38Ne8Ayk/ybs5qI82bYTVYfPmz+oUCVv6RySrwnPnFIrADf4JxY
         hDMKoJSdsGIzxpVLyIa5el4BYXdC8h6jvtVNH/AayRv/p4Y+mUAognMx692EkWdF1M5W
         3bkK7V+VALQMdF3JjfLJgPPUFxvFvTX6sASRE=
MIME-Version: 1.0
In-Reply-To: <1282595927.11194.78.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net> <1282077040.16098.47.camel@mulgrave.site>
 <4C6C1DC1.8090208@vlnb.net> <1282164188.10878.22.camel@mulgrave.site>
 <4C702030.2070306@vlnb.net> <1282423128.3015.35.camel@mulgrave.site>
 <AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
 <1282582740.11194.17.camel@mulgrave.site> <4C72CEC5.4080204@vlnb.net> <1282595927.11194.78.camel@mulgrave.site>
From: Chris Weiss <cweiss@gmail.com>
Date: Tue, 24 Aug 2010 08:01:06 -0500
Message-ID: <AANLkTikbyEtMiJ2ii3TreJGsbqz4Kf61WvzkwFDDOo4L@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 3:38 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>      * STGT users should just migrate to scst_local
>      * STGT doesn't have enough users to bother with
>      * STGT has fundamental design flaws which makes its pass through
>        architecture unusable and its ABI flawed.
>
> I'm sure STGT appreciates the frank assessments, but it doesn't seem to
> merit too many "plays well with others" points.

I get what you are saying, and I haven't use STGT, but if these things
are true (especially the last), well truth sometimes hurts,
and if they aren't true, why replace the target anyway?

There is also some precedence for dropping features, at least
temporarily and sometimes longer, to move to a new backend.  In fact I
have a fax server that I still have to run on a specific 2.4 kernel
version because latter 2.4's and all 2.6's serial subsystem don't
quite work right with the old hardware.  Sometimes you do have to drop
some old code to move forward, and hope someone that cares will fix
it, and sometimes there really is not enough users to bother with.

I haven't tried using LIO for nearly 3 years, at which point I was not
able to connect a VMware ESX initiator and transfer data reliably, and
Nick really didn't seem to care.  SCST works, and Vlad worked quite
hard helping me both with config issues and code patches to making it
rock stable with great performance.  If my memory serves, at the time
STGT was documented to have issues with ESX so i didn't even bother
testing it.  I also rarely see any technical conversation on LIO
lists, I actually thought the project had gone slightly stale or
niche, until this thread.

Let me also toss this out there:
How many commercial iscsi products are based on LIO, and certified to
work with other commercial products?
I don't ask this because I think the kernel should listen to the whims
of commercial products, I ask because working with things that aren't
Linux is a clear sign of "plays well with others".  Does LIO actually
play well with others, not just its lead developer?
