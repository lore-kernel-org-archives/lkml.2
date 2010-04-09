Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab0DIVly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:41:54 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:4165 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550Ab0DIVlx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:41:53 -0400
From: Frans Pop <elendil@planet.nl>
To: "=?iso-8859-1?q?=C9ric?= Piel" <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input interface
Date: Fri, 9 Apr 2010 23:41:49 +0200
User-Agent: KMail/1.9.9
Cc: jkosina@suse.cz, akpm@linux-foundation.org, samu.p.onkalo@nokia.com,
       pavel@ucw.cz, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       marcin@derlukiewicz.pl
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz> <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz> <4BBF2BD1.5050107@tremplin-utc.net>
In-reply-To: <4BBF2BD1.5050107@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201004092341.51246.elendil@planet.nl>
X-OriginalArrivalTime: 09 Apr 2010 21:41:51.0570 (UTC) FILETIME=[77093320:01CAD82D]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Éric Piel wrote:
> Are you saying there is a 20% CPU usage even when the joystick interface
> is not open? This should not happen (and this is not happening on my
> laptop).

I've also never seen this problem on my HP 2510p.
