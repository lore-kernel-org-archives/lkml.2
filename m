Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab2EIJNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:13:19 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:33030 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758929Ab2EIJNS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:13:18 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2012 05:13:18 EDT
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: 3.3.x: e1000 and ixgbe hang
Date: Wed, 9 May 2012 11:07:11 +0200
User-Agent: KMail/1.9.9
References: <201205082330.12831.wolfgang.walter@stwm.de> <20120508215645.GA22200@kroah.com>
In-Reply-To: <20120508215645.GA22200@kroah.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201205091107.11820.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 8. Mai 2012 schrieben Sie:
> On Tue, May 08, 2012 at 11:30:12PM +0200, Wolfgang Walter wrote:
> > I would be very glad if these two patches will make it into the next
> > stable 3.3:
> >
> > http://article.gmane.org/gmane.linux.drivers.e1000.devel/9948
> >
> > Dave Miller said that he will take care of it:
> >
> > http://article.gmane.org/gmane.linux.drivers.e1000.devel/9993
>
> If he said he would take care of it, why are you posting it here again?

a) Because it didn't make it into 3.3.5. The fix (for 3.3.x) is known since 
2012-04-20 and I find it appropriate to remind of it after more than two 
weeks.

b) To document the bug (which makes 3.3. i.e. unusable for us) and that there 
are fixes in the stable mailinglist and not only in e1000-devel (especially 
as it isn't a e1000 specific problem).

c) I met 2 colleague yesterday which had the same problems but didn't know 
there was a fix.

c) Dave Miller is a busy man.

It's unclear how one should use new kernels if it is difficult to find known 
fixes.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
