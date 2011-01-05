Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab1AENwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:52:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46460 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1AENv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:51:59 -0500
Date: Wed, 5 Jan 2011 13:51:55 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Alex Arnautu <alex.arnautu96@gmail.com>
Cc: Kernel Team <kernel-team@lists.ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: Sound problem
Message-ID: <20110105135155.GR18715@shadowen.org>
References: <AANLkTim-CAYHJyQO3oNiyvAZoM-ep6JkYU9y6ATOwMW2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim-CAYHJyQO3oNiyvAZoM-ep6JkYU9y6ATOwMW2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 06:23:42PM +0200, Alex Arnautu wrote:

> I'm having problems with sound. I tested 2.6.35-24 generic and
> 2.6.37-rc8. The problem is that on stable version, I can talk with my
> friends on GMail or Skype but I can't record sounds with "Sound
> Recorder". On the testing version I can't even talk on GMail or Skype
> with my microphone. I atached the dmesg files for 2.6.37-rc8 and
> 2.6.35-24 generic.

If the mic is working in some applications this is much more likely a
userspace issue than anything else.  I would recommend filing a bug
against 'alsa-driver' for Ubuntu at least as this will get us all of the
logs and configurations we need to investigate; you can use 'ubuntu-bug
alsa-driver' to file this.

-apw
