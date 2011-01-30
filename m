Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1A3Ws5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 17:48:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50686 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab1A3Ws4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 17:48:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Sun, 30 Jan 2011 23:48:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D445319.5020803@pardus.org.tr> <4D45CA6F.8000002@pardus.org.tr>
In-Reply-To: <4D45CA6F.8000002@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101302348.40509.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 30, 2011, Ozan Çağlayan wrote:
> On 29.01.2011 19:49, Ozan Çağlayan wrote:
> 
> > intel_idle enabled and the patch above applied. Got 1 feedback for now
> > which tells that 1 out of 2 shutdown attempts failed. This is on Asus
> > N61JQ (https://bugzilla.kernel.org/show_bug.cgi?id=27412).
> >
> >
> 
> intel_idle + patch above doesn't help to the boot hang of Asus X61S.

Does booting with "nolapic" help on all of the affected systems?

Also, does disabling the CPUidle during boot help?

Finally, is the problem reproducible with CONFIG_NO_HZ unset?

Rafael
