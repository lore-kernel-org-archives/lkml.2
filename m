Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab0CXUre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:47:34 -0400
Received: from web94910.mail.in2.yahoo.com ([203.104.17.172]:45460 "HELO
	web94910.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751221Ab0CXUrd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:47:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2CJRgubTVjw1rLKYlc+ftHgaJkiHuR1/7Ua5w42HwupqwG8BGLn0tH1VAH8nbOJkCKJOB7Ofwf3Iv8Zb3n4PDoNipEU6RjEZBT6dL1TxkOwiobbxxVmzfvZJJM0Dza+fJZ7CZr5FM2wq5KE6nLUcZb8K0LQ70psIDcT1gTuosX4=;
Message-ID: <259746.71412.qm@web94910.mail.in2.yahoo.com>
X-YMail-OSG: rnGBc8YVM1mAqA.sny4_A1Y0q5SsWxkvBsNUhihqDlw.J2u
 oFjGgp7IgRfaOiGIQmyqG1iKgOMadwhtqm1SdIQSJ3OzxMYLH7xZ2h21AKaJ
 0.tJ9W7JQE2Z7CfKlxMgGRbKbjEcul6lGpeysBTntIfXlBDcIXZTVbNPJq5E
 7.MZk0hfNd4pcijJhyfGE8Z1c6Xw.Ss5cU6bmF9LQBw0Cz5qoJ0P22wrGQwU
 W7.S9lRyVGBlsuF4BimJYSqZy_AOly2dD94Nw3Lshp9fp674SMVwVmWHjQkz
 u.3wliIBhQYrCg78VSh8n
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 25 Mar 2010 02:17:30 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 2/7] drivers:staging: Kconfig, Makefile for TI's ST ldisc
To: pavan_savoy@ti.com, Greg KH <gregkh@suse.de>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Greg KH <gregkh@suse.de> wrote:

> From: Greg KH <gregkh@suse.de>
> Subject: Re: [PATCH 2/7] drivers:staging: Kconfig, Makefile for TI's ST ldisc
> To: pavan_savoy@ti.com
> Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
> Date: Wednesday, 24 March, 2010, 8:00 AM
> On Tue, Mar 23, 2010 at 03:41:10PM
> -0500, pavan_savoy@ti.com
> wrote:
> > From: Pavan Savoy <pavan_savoy@ti.com>
> > 
> > This change adds the Kconfig and Make file for TI's
> > ST line discipline driver and the BlueZ driver for BT
> > core of the TI BT/FM/GPS combo chip.
> > 
> > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > ---
> >  drivers/staging/Kconfig     
>   |    2 ++
> >  drivers/staging/Makefile   
>    |    1 +
> 
> To add a new staging driver, I need a TODO file that lists
> what needs to
> be done to the code in order to get it merged into the main
> portion of
> the kernel, and who is responsible for it.  Look at
> the other
> drivers/staging/*/TODO files for examples of what to do.

Oh - BTW, I've added patches on tree 
http://github.com/PavanSavoy/testGit/tree/patch_branch

also, got by git clone git clone git://github.com/PavanSavoy/testGit.git
and checking out --track -b patch_branch origin/patch_branch
have fixed the ordering of patches and TODO/ABI moved into staging.

Just in case, you decide to put this in staging/ i can re-mail them too.

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>




      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
