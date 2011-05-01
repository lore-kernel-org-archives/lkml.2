Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1EAHor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 03:44:47 -0400
Received: from smtpout02.highway.telekom.at ([195.3.96.113]:24468 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752270Ab1EAHoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 03:44:44 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: "Joey Lee" <jlee@novell.com>
Subject: Re: acer_wmi: "Unable to detect available WMID devices" on Acer_Travelmate_5735Z-452G32Mnss (was: Re: i915/kms/backlight-combo mode problem)
Date: Sun, 1 May 2011 09:44:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
Cc: carlos@strangeworlds.co.uk, tiwai@suse.de, linux-kernel@vger.kernel.org
References: <4DBD9716020000230002C094@novprvlin0050.provo.novell.com>
In-Reply-To: <4DBD9716020000230002C094@novprvlin0050.provo.novell.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105010944.41452@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joey Lee -- Sunday 01 May 2011:
> I am tracing DSDT for why the WMID2 method return acpi fail, and maybe
> this machine direct support standard ACPI backlight method.

Excellent!  :-)



> Does this machine's backlight control works before 2.6.39 kernel? I mean
> does backlight control works fine on 2.6.38 or 37 or even older kernel ?

Yes, it worked before, but also only with acpi_osi=Linux. I'm not
sure about the versions, but I think it already worked with whatever
opensuse 11.3 and 11.4 came with (some 2.6.34.* and 2.6.37.*). This
notebook came with "Linpus" Linux pre-installed, and everything
worked with that. Unfortunately, the notebook specific code was
apparently put in a binary blob module. Disgusting.

m.
