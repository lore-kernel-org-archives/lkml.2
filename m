Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1F3WGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44653 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab1F3WGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:06:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marc Koschewski <marc@osknowledge.org>
Subject: Re: [REGRESSION] suspend/resume broken on T510
Date: Fri, 1 Jul 2011 00:07:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <20110630220050.GB30291@marc.osknowledge.org>
In-Reply-To: <20110630220050.GB30291@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107010007.27588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, July 01, 2011, Marc Koschewski wrote:
> Hi guys,
> 
> I just thought to wait some what longer than -rc3 to report: suspend/resume is
> broken in the current git. I blacklisted the 'mei' module so the suspend worked
> as of rc4 (last 'first tested and working' version) with knowledge of the
> mei-bug.
> 
> However, my system does not resume anymore on my T510. After suspend the 'moon'
> turns on as usual on 3.0.0-git and the box sleeps. After opening the lid it somehow
> wakes up but doesn't boot/resume. It just stalls after some HDD activity.
> 
> If have no idea what it could be - and I unfortunately cannot bisect it down to
> anything > 2.6.39. I left out rc1 and rc2 this time due to having no time to
> experiment this month. However, my .config is attached if anyone needs it...

Well, perhaps let us know the hardware configuration (attach dmesg?).

Anyway, I'm not sure if there's anyone who can figure out what _may_ be wrong
on the basis of your description alone.  It would be good if you could file
a bug in http://bugzilla.kernel.org and let me know its number.

Thanks,
Rafael
