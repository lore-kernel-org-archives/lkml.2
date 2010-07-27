Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0G0Qzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:55:51 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39585 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0G0Qzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:55:50 -0400
Date: Tue, 27 Jul 2010 18:55:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: trapDoor <trapdoor6@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Small typo in kernel [current source from git] .config option
Message-ID: <20100727165549.GC26649@merkur.ravnborg.org>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 03:46:45PM +0100, trapDoor wrote:
> Hello,
> I've just got lucky and found this little typo under "Power management
> and ACPI options"  ---> "ACPI (Advanced Configuration and Power
> Interface) Support":
> hArdware Error Device
> 
> Here is my fix:
> Hardware Error Device
> :)
> 
> BTW, first time I've used nconfig instead of menuconfig. And I like it.

The capital "A" is nconfigs way to tell you that you can use
"a" as shortcut to reach the menu.

	Sam
