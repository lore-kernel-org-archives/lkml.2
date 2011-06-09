Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1FIHWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:22:20 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:44469 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab1FIHWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:22:05 -0400
Message-ID: <4DF0749A.2040506@profihost.ag>
Date: Thu, 09 Jun 2011 09:22:02 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Theodore Tso <tytso@MIT.EDU>,
        david@lang.hm, linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
References: <4DEE1D96.6020208@profihost.ag> <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu> <4DEE2C70.8060301@profihost.ag> <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm> <4DEE9EDA.90001@profihost.ag> <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu> <20110608133037.GF27245@home.goodmis.org> <20110609025742.GS32466@dastard>
In-Reply-To: <20110609025742.GS32466@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want someone to blame, then point the fingers at me, not
> RedHat or RedHat's processes - RedHat is not involved in the
> processes and decisions as to what fixes
> get backported into the community stable trees. How that is done
> is mainly dictated by available resources, which are generally
> scarce. We push bug fixes into the lastest kernel release, and if
> known to be needed for stable series they get pushed back via the
> stable queues.
I'm really sorry that my post goes that way. It was never my intention 
to blame anybody for anything.

I just didn't know the things work and was just wondering that Redhat 
had a fix which wasn't pushed back to vanilla 2.6.32. But i also didn't 
know that the xfs codebase is totally different due to other backports.

I'm sorry.

Stefan
