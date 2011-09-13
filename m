Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1IMUUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:20:21 -0400
Received: from claw.goop.org ([74.207.240.146]:35558 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab1IMUUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:20:20 -0400
Message-ID: <4E6FBB00.9090803@goop.org>
Date: Tue, 13 Sep 2011 13:20:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org> <4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org> <4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org>
In-Reply-To: <m2aaa89t1m.fsf@bob.laptop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 11:49 AM, Chris Ball wrote:
> I just asked Matthew Garrett to check his X220, and his has the same e823
> controller as you, is running a 3.1-rc kernel, and everything's working.
>
> So it's not even variation in the controller model, it's something even
> more subtle.  Perhaps try some different cards?  What capacity/speed is
> the one you're trying?  If there is a per-card difference, I suppose
> we'd expect it to be that slower cards work and faster cards fail
> (given the nature of the patch I linked in my last mail).

I have two: a PNY 8GB Class 10 card, and an EyeFi Connect X2 4GB, class 6.

    J
