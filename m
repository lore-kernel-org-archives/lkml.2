Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0LHWqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:46:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43335 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755496Ab0LHWqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:46:46 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18BuvAgeDwB6kcZHyqU0tt3K3qHfC5xxO6lmGk5Yo
	B8DbHJD/K1DRq/
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] staging/line6: Fix sparse warning 'Using plain integer as NULL pointer'
Date: Wed, 8 Dec 2010 23:46:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        Markus Grabner <grabner@icg.tugraz.at>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, Tejun Heo <tj@kernel.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1291761482-28500-1-git-send-email-peterhuewe@gmx.de> <20101208223023.GA1860@kroah.com>
In-Reply-To: <20101208223023.GA1860@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012082346.44392.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 08 Dezember 2010, 23:30:23 schrieb Greg KH:

> It builds just fine for me here, what errors are you seeing?
Sparse errors ;) - I'm still getting confused what the output of sparse and 
what the output of gcc is.
Sorry about that - code builds fine.


Peter
