Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0KBOP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:15:27 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:57176 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab0KBOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:15:23 -0400
Message-ID: <4CD01CD8.3090206@stericsson.com>
Date: Tue, 2 Nov 2010 15:14:48 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        <linux-input@vger.kernel.org>
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com> <20101102140337.GC9387@kroah.com>
In-Reply-To: <20101102140337.GC9387@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

>> +Wait for the official upstream synaptics rmi4 clearpad drivers as promised over the past few months
>> +Merge any device support needed from this driver into it
>> +Delete this driver
> 
> Huh?
> 
> Why not just add this driver to the kernel tree instead?  When the
> "promised" driver then eventually shows up (who is promising it?) then
> delete the thing.

Well, Alan (on behalf of Ramesh Agarwal) sent out a very similar
patch (Titled "Synaptics TM1217 Touchscreen Controller driver")
the other day, and OTOMH that was after discussions with Synaptics
where they said they were working on a "real" driver (a rather
complex RMI4 bus driver) and we believe they will fix that sooner
or later.

So, until sooner or later happens we thought we'd keep it in staging.

If you prefer both Alan and we can probably submit our patches for
inclusion in the proper place.

A side effect may be that the Synaptics RMI4 people may have trouble
to merge their driver into input/ since they may be requested to
refactor the existing drivers to use it rather than merging new stuff,
putting some burden on their shoulders.

Yours,
Linus Walleij
