Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1EaC10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 22:27:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:34181 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1EaC1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 22:27:25 -0400
Date: Mon, 30 May 2011 19:26:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Ted Ts'o" <tytso@mit.edu>
cc: "D. Jansen" <d.g.jansen@googlemail.com>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
Message-ID: <alpine.DEB.2.02.1105301923330.5766@asgard.lang.hm>
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
 <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com> <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com> <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm> <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
 <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Ted Ts'o wrote:

> On Mon, May 30, 2011 at 11:24:03PM +0200, D. Jansen wrote:

> It's probably some application like firefox, or syslog.  (Syslog can be 
> fixed by prefixing syslog.conf entries with the '-' character so that 
> the files aren't sync'ed after every log update, for example.  Or not to 
> log as much in the first place.)

note that rsyslog (which is the default on new versions of just about 
every distro) changes this default so it no longer does a fsync for each 
log entry. It can be configured to be ultra paranoid if you need it, but 
by default it's not.

David Lang
