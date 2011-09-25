Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1IYUsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 16:48:40 -0400
Received: from nm7-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.167]:29870 "HELO
	nm7-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752840Ab1IYUsj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 16:48:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 841686.82564.bm@omp1053.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xhpFChLKuOjJYGjthsX3F55via7ab45Kn5rxKYThBEvATzmBHZR/8od9ZjN4ef4z3Ggcrm8pFaXBxH3wNyU4dEK9xXNlRN9tKEM2v04kRjpR72pgsWKrJJzYMj922hWbNOF77+dCCAkNALGnwldzy5mYxZyxCKJyIw79EYyUpGg=;
X-YMail-OSG: dLHvet8VM1n_XmSIGKIBuTV55bBTKkuW09UyLuftDHr4HTo
 4XkiIbn.WerSrxZpTZkHRLcVKF1mWIrkiSGgUpF0Rvl5q_rqOjZplmFbUVln
 ymoAbfZMDCOL12GUwCKZe4M1YIWGBo.Ee1N240UIDQqnfw75POgkOJ5jgWfH
 9ZFNYWQAF7EBNN7niRisWgEg2CJ3t_FlAH14d9jypcR2gVdeD.C1YIkVtvp3
 vndBeNRxNObDSta0IHIgDWlTynfm60rjnpXh9MbvVZHSc_tRWeg45_wGLgW2
 DnemnSsunCuJAq_q_y36HCZJ9diHLGe77v0XymJ33jze8yIDc4.co1lgi43J
 qURrwT20rXUR6KlAERZb59ACybY3XDiirW9EFt0_8praJL4EgHjHQZhpJrYz
 oHLNsXWYwVHjlCn2hud.7hDrbX9ve5ER12HNe0fv3xVyWuu5lfVfRaZbkIMO
 Ou4qf9NZYaJaW5J7yxRGi1hLDnQ2Fv4JwnCBnyHCO3H5ofDOtoY0r49iTqHQ
 AnRbjuTbyRwEs7Kf4f.PxyfPoAy0-
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com> <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com> <yun39fkpdqf.fsf@aiko.keithp.com>
Message-ID: <1316983717.135.YahooMailNeo@web130122.mail.mud.yahoo.com>
Date: Sun, 25 Sep 2011 13:48:37 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
To: Keith Packard <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <yun39fkpdqf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometime in the recent past, Keith Packard said:
>Are yo using the drm-intel-fixes branch there? That's the one with the
>FBC disable stuff.
>
Here's the command I used:

git clone -b drm-intel-fixes git://anongit.freedesktop.org/~keithp/linux


The first git log entry:

commit cd0de039bff32ee314046c0e4c047c38aa696f84
Author: Keith Packard <keithp@keithp.com>
Date:   Mon Sep 19 21:34:19 2011 -0700

    drm/i915: FBC off for ironlake and older, otherwise on by default


I'm new to git. Is there anything else I should've done?

>Alternatively, you can just disable FBC manually by adding the kernel
>argument:
>
>        i915.i915_enable_fbc=0
>
I'll give this a try.
