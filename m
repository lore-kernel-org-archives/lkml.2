Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab1FWV5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:57:37 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:52634 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1FWV5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:57:36 -0400
X-RZG-AUTH: :O2kGeEG7b/pS1EO8W3C+nMaWotNRcyCeCTTmQgOI2iYXpKw2M5aRJ08f0llfYruJ9g==
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1/1] drm/radeon: Fix Asus M2A-VM HDMI EDID error
 flooding problem
From: Thomas Reim <thomas.reim@nepomuc.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: reimth@googlemail.com, Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
In-Reply-To: <BANLkTin8PpQWrGaCCQMQY+6A5QnXWxsKDQ@mail.gmail.com>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
	 <1308705639-4215-1-git-send-email-reimth@gmail.com>
	 <BANLkTin-04ki+BgW-d1HqS5oupsx05ThUQ@mail.gmail.com>
	 <1308755870.3655.36.camel@Mark-Aurel.gas.de>
	 <BANLkTin8PpQWrGaCCQMQY+6A5QnXWxsKDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 23:57:10 +0200
Message-ID: <1308866230.7848.2.camel@Mark-Aurel.gas.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alex,

> I think it would be better to add a quirk flag and only do the
> extended probe on specific boards where it is required.  E.g.,
> 
> if (radeon_connector->requires_extended_probe)
>     radeon_ddc_probe_extended();
> else
>     radeon_ddc_probe();
> 
> Alex

Today, I updated the patch according to your proposal and the proposals
of Jean. I'll send it with my next mail.

Best regards

Thomas

