Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1IXPUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 11:20:36 -0400
Received: from nm33-vm3.bullet.mail.ne1.yahoo.com ([98.138.229.67]:21762 "HELO
	nm33-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751091Ab1IXPUf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 11:20:35 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Sep 2011 11:20:35 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 869408.92418.bm@omp1058.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xHs54L/KkwqDGazDRFqx68JfLxBQKOG0GbHZZrjR0pOfSfGwlZS4jZQuPLJhP4YOoAPLB70QpLToY5giCfLi53dwjMSvPtTMwA3n+96PpzDPQsipS5dMsbQD8xUbxeUf/bKAauNtRiWbAtSZqoNZ2yQxFyTC6dcWXLKHp9DDXqE=;
X-YMail-OSG: 1.ghdpcVM1ktS0OBV86HWARje9bcUL.t4PUHlEcILow4iyM
 PXeOvcgRaMpu69Ol8p786K1IATh8VIqLaCiRa8pOvNZ2Chra_Koj6D2ESX3a
 BUM8y9aywcXxziJoDjp1WV_T4.uioCOQjX2d1pYs9c3G4WOEfaTGzlYZf2Re
 KpIBu7WyLnVEJ7Txpjn5lCEdV9iSX9Ky7fISYypUx2sT74nzSFDo_FF5C5at
 .GsqDifnwOSWhCTH7v7nx3Xfg_59zpK3BlH736WjTTltt3P4.XVel8WZn_fh
 RsRJZhtZN4NdNncDl7Ay9id7Y9DTLkx3X8msYPaHqQn2XMvAyiN6FHPv.sje
 IZ8gWSCQkzozsiYyQX7BC_KgtrLPUSvmLiJZ4jwcAyygGbG0oGTkUDad7t5B
 fu1Vq8Vvv9PkeYfM2bHTGj96p3yFjFpRK3EPWW3LMuL0Jx1J42mgyj_6Kr9v
 bBmbX0uxOv9trMSVWK3vVlK_SQa.nl0g3O5amhlbW.kj.Zx5feR3T893Aerc
 .mRHWIk9EfJxKXcjG4UcnB45q4_ljgybz5cyOnE4D8E4oHD4O
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com>
Message-ID: <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com>
Date: Sat, 24 Sep 2011 08:13:42 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
To: Keith Packard <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <yunvcsim1wk.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard <keithp@keithp.com>

To: Alex Davis <alex14641@yahoo.com>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: 
Sent: Saturday, September 24, 2011 10:48 AM
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1

>If you can, please send along a kernel log with drm.debug=5 and the
>output of intel_reg_dumper run when the screen is working and when it is
>black -- you'll need to use ssh from another computer to capture the
>latter.
>
>intel_reg_dumper can be found at:
>
>        git://anongit.freedesktop.org/git/xorg/app/intel-gpu-tools
>
>I suspect you're hitting some of the backlight changes. Hard to believe
>that something as simple as a light could be so complicated...

Thanks for the info, will do this early next week.

One good thing about the 3.1 kernels is that I now have the /sys/class/backlight/intel_backlight directory
in addition to /sys/class/backlight/dell_backlight. With intel_backlight, I can control the LCD brightness;
dell_backlight never worked, neither in 3.0 or 3.1.

