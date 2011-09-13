Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1IMUio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:38:44 -0400
Received: from claw.goop.org ([74.207.240.146]:35589 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab1IMUim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:38:42 -0400
Message-ID: <4E6FBF4E.7000103@goop.org>
Date: Tue, 13 Sep 2011 13:38:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Manoj Iyer <manoj.iyer@canonical.com>
CC: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org> <4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org> <4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org> <alpine.DEB.2.02.1109131419430.3556@lazy> <4E6FBCA1.6040307@goop.org>
In-Reply-To: <4E6FBCA1.6040307@goop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 01:27 PM, Jeremy Fitzhardinge wrote:
> I have 1.17 installed at the moment.  It looks like 1.21 is current, so
> I could try updating it.  But the Fedora 15 2.6.38 kernel worked fine
> with this controller and cards, so I don't think BIOS version is an
> issue.  Also, there's nothing obviously related to the SD controller in
> the release notes (not that I trust their competeness).

...but in preparation for doing a bisection, I can't actually find a
kernel version which works any more.  So... I'm not sure what changed. 
Maybe it was the BIOS.

    J
