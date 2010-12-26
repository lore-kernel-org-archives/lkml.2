Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0LZWBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:01:50 -0500
Received: from nm29-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.248]:41273 "HELO
	nm29-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752323Ab0LZWBt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:01:49 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 620194.42122.bm@omp1066.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=C7vkYZLvvNYhdBfmVuu2KCkCfSXZyh2sxGW5k89umhcTLRL1MGRPBhereMiGA9nN+8WwDbZF0clWPJQtvr88cmaSiCAvUI7PsfTo8qOag6mHf4KdWbU3NDHirzJgM1eb7cbzvUYdFsy1utmTWpnpHnE5P3jseLvEqg0kjGwch4E=;
Message-ID: <489629.5504.qm@web65703.mail.ac4.yahoo.com>
X-YMail-OSG: PFuzjHUVM1nAxTOiY1MTxKeDb4zaaESGJtR5ndd3mEiUGap
 jiZ7k50K13RWw73KTlEoOyYhRnJvW8V1uf1EWVcHtgfCN.KM7hxsMPwFlFOd
 .iN5APFSABZ9_7otaeOWY93tJdEhl36q_xn4PKO8q1hEv6oR4yMIiOVsnTvM
 GYekqi8RI2sCTbQ8wNbF3Zv3DJM2qU6BwL7yS3Zxi12Z9XXCDXxqvZ1Zwm8E
 8TQlM4kQU_BY.z8oQ_Xv9nEzY7OqJ4fWcCIt.TIv1sOTd0G_CPLx9Stiqjr0
 nJl9yIyf0Ot9RHHma9IXXvnOMkESwQ8davUiHPDE.m9Ol13mJg3RIgL7cAk7
 5IUPhQZv7t9wICVWauZ22_W64RUSPgaO0TYaXVM0dVy.Qme5EgJ4x
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sun, 26 Dec 2010 14:01:48 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101226133011.c7a3508d.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

Greg referred to git as to place where change log comments are now checked in. I googled it and found that one can also check out latest kernel source code as opposed to tarball download. However, You're right, looking at http://kernelnewbies.org/UpstreamMerge/SubmittingPatches documentation I don't see how one can use git to check in comments or code directly to git repository,

Thank you,
Vadim.


--- On Sun, 12/26/10, Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
> To: "Tsozik" <tsozik@yahoo.com>
> Cc: "Greg KH" <gregkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Sunday, December 26, 2010, 4:30 PM
> On Sun, 26 Dec 2010 11:51:28 -0800
> (PST) Tsozik wrote:
> 
> > Greg,
> > 
> > Many thanks for your reply. I will try to install git
> and download the latest release candidate. I see that
> 2.6.37.rc7 is already available. I think I will also hope to
> find get_icount there to address Pete's concern,
> 
> 
> You can use git if you want to, but it certainly is not
> required for this.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when
> testing your code ***
> desserts:  http://www.xenotime.net/linux/recipes/
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
