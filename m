Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab1LTIqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:46:33 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:47460 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1LTIqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:46:25 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Subject: Re: [PATCH v2] Input: bcm5974 - Fix USB autosuspend
Date: Tue, 20 Dec 2011 09:47:58 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
References: <1324314123-2200-1-git-send-email-rydberg@euromail.se> <201112191842.08635.oliver@neukum.org> <20111219203059.GA6749@polaris.bitmath.org>
In-Reply-To: <20111219203059.GA6749@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112200947.58504.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 19. Dezember 2011, 21:30:59 schrieb Henrik Rydberg:
> Matthew: There seems to be a problem with the hardware wake-up in
> response to short taps on the trackpad. Too much of a regression to be
> acceptable, I am afraid. Unless this laptop (MBA 3.1) turns out to be
> a special case, I think we will have to let this patch rest.

I always hoped for an API to let user space tell the driver that a slight
degradation in responsiveness is now acceptable, for example because
the screen saver is running.

	Regards
		Oliver
