Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2DNA76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:59:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41481 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752626Ab2DNA7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:59:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18c9axv7DoccWpTzCXcUkoHT+XwymgsuIj21F++Oj
	jX1KEuqrdEa33u
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH 1/2] drm/nouveau: Add lock on drm_helper_resume_force_mode
Date: Sat, 14 Apr 2012 02:59:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.1; KDE/4.7.3; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Christian =?iso-8859-1?q?K=F6nig?= <deathsimple@vodafone.de>,
        Michel =?iso-8859-1?q?D=E4nzer?= <michel.daenzer@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable@kernel.org
References: <1334362145-27627-1-git-send-email-peterhuewe@gmx.de> <20120414005219.GG13995@burratino>
In-Reply-To: <20120414005219.GG13995@burratino>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204140259.33243.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 14 April 2012, 02:52:19 schrieb Jonathan Nieder:
> Hi,
> 
> Peter Huewe wrote:
> > mode_config should be locked when calling drm_helper_resume_force_mode.
> > This patch adds the lock, similar to #927a2f119.
> 
> Does this fix a problem that has been observed in the wild, or only a
> theoretical one?
> 
> Curious,
> Jonathan

Only theoretical ;)
Since all other drivers always lock around drm_helper_resume_force_mode I 
guessed this is good practice.

And since problem area is quite similar to the one mentioned in #927a2f119 / 
234f78a683e 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-
stable.git;a=commit;h=234f78a683e30d6d4628846fde4a822c0e385529
the bug might happen in the wild.


Thanks,
Peter
