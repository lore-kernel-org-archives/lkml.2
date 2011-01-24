Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1AXJEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:04:39 -0500
Received: from nm14.bullet.mail.ukl.yahoo.com ([217.146.183.188]:43893 "HELO
	nm14.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751392Ab1AXJEh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:04:37 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 337369.42729.bm@omp1016.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RLPIZUXLf+iq8m+aP2AlZIrR00EArTQD8SBaiX2ZmTk1mz2LlF6Qw2q/nXnVshUJ6t+jzyAGDhj6W+cPcZniL5tCCeRZm7iKPXmeROJDxSy3whXwOdnEUy0XnbOKbwmeRCBV2FTRB0sZdlyelCKORSKmED+6CHRBT85cmQXBIJ8=;
Message-ID: <179044.7274.qm@web28416.mail.ukl.yahoo.com>
X-YMail-OSG: EwoRuDwVM1leZylDEZ4RskAsKAW0BdcIOCBAzHYTnxaU2_0
 uxPn6XF.4
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 24 Jan 2011 09:04:35 +0000 (GMT)
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl,
        colin.king@canonical.com,
        =?utf-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
In-Reply-To: <4D3C8E90.6010506@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- En date de : Dim 23.1.11, Ozan Çağlayan <ozan@pardus.org.tr>
a écrit :

> De: Ozan Çağlayan <ozan@pardus.org.tr>
> Objet: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
> À: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org, rjw@sisk.pl, colin.king@canonical.com
> Date: Dimanche 23 janvier 2011, 21h24
> On 23.01.2011 16:28, Ozan Çağlayan
> wrote:
> > Hi,
> >
> > I'm getting a lot of bug reports about hanging
> boot/shutdowns on these
> > days.
> >
> > Most of the affected hardware are ASUS laptops. The
> problem is that I
> > don't have access to any of those problematic laptops
> and the users are
> > not able at all to debug/bisect what is going on.
> However, I have
> > collected dmesgs of good/bad boots, acpidump, etc.
> >
> > Here are the current status:
> >
> > "Asus F50SV does not boot unless lapic is passed"
> > https://bugzilla.kernel.org/show_bug.cgi?id=26502
> >
> > "Regression between 2.6.35-020635-rc1 and
> 2.6.35-020635 breaks acpi
> > support on Asus X71 laptop"
> > https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/689796
> >
> > "Asus N61JQ hangs at shutdown unless lapic is passed"
> > (Not reported upstream yet, I've only downstream bug
> report which is
> > Turkish)
> > http://bugs.pardus.org.tr/show_bug.cgi?id=15969
> >
> > "Asus X61S does not boot unless acpi=off is given"
> > (Not reported upstream yet, I've only downstream bug
> report which is
> > Turkish)
> > http://bugs.pardus.org.tr/show_bug.cgi?id=16322
> > (I've told the reporter to try with nolapic, it will
> probably fix the
> > issue but until confirmed acpi=off is the only
> solution. 2.6.36 was fine)
> >
> > I'll post more bugs in here as I've found them.
> 
> (CC'ing: Colin King from Canonical)
> 
> Another one for Asus N90Sc which was booting fine with
> 10.04
> but fails to boot with 10.10:
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/653626
> 
> Seen that the issue mostly happens on Asus boxes, it's
> possible
> that their firmwares are buggy but they were
> booting/shutting down
> correctly until a recent change in kernel.
My ASUS F3Jv-AS022P (Core 2 Duo T7200, 2 GB RAM, BIOS version
207) has trouble (read: it reboots within one second of the
vmlinuz being loaded) with recent kernels as well.

While I haven't performed a full bisection yet (which is why 
I didn't try reporting the problem until I saw this thread),
I have narrowed down the problem by compiling several tagged
versions:
* 2.6.35 series: .4 and .6 boot successfully, .8 and .10 fail;
* 2.6.36 series: -rc2 boots successfully, .1 fails;
* 2.6.37 series: -rc4 fails.


I can perform further testing if needed.


Regards,
Lionel.


      
