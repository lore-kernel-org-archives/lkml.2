Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab1JaK2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:28:44 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:37958 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab1JaK2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:28:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: kernel panic on device removal when using a workqueue and delayed_work
Date: Mon, 31 Oct 2011 11:29:25 +0100
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc9-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4EADA32E.6030200@googlemail.com> <20111031031136.GA18057@zhy> <4EAE77F2.80102@googlemail.com>
In-Reply-To: <4EAE77F2.80102@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110311129.25277.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 31. Oktober 2011, 11:26:58 schrieb Frank Schäfer:
> Am 31.10.2011 04:11, schrieb Yong Zhang:

> >> This is the first time I'm using a workqueue, so there is a good
> >> chance that I missed something...
> > You should cancel the work you have armed before exit.
> > See cancel_delayed_work().
> That's what I'm doing (see above).
> Did you read the code ? ;-)

Does it work if you set a flag and resubmit the work only conditionally
on it?

	Regards
		Oliver
