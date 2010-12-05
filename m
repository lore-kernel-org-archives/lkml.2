Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0LELLG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 06:11:06 -0500
Received: from lo.gmane.org ([80.91.229.12]:58647 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab0LELLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 06:11:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: [PATCH v4] sched: automated per session task groups
Date: Sun, 05 Dec 2010 13:11:20 +0200
Organization: Lucas Barks
Message-ID: <idfrvp$l4o$1@dough.gmane.org>
References: <1289783580.495.58.camel@maggy.simson.net>	<1289811438.2109.474.camel@laptop>	<1289820766.16406.45.camel@maggy.simson.net>	<1289821590.16406.47.camel@maggy.simson.net>	<20101115125716.GA22422@redhat.com>	<1289856350.14719.135.camel@maggy.simson.net>	<20101116130413.GA29368@redhat.com>	<1289917109.5169.131.camel@maggy.simson.net>	<20101116150319.GA3475@redhat.com>	<1289922108.5169.185.camel@maggy.simson.net>	<20101116172804.GA9930@elte.hu>	<1290281700.28711.9.camel@maggy.simson.net>	<AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>	<AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com> <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-378860.home.otenet.gr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101028 Thunderbird/3.1.6
In-Reply-To: <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2010 10:01 PM, Colin Walters wrote:
>[...]
> Speaking of the scheduler documentation - note that its sample shell
> code contains exactly the problem showing what's wrong with
> auto-grouping-by-tty, which is:
>
> # firefox&	# Launch firefox and move it to "browser" group
>
> As soon as you do that from the same terminal that you're going to
> launch the "make" from, you're back to total lossage.  Are you going
> to explain to a student that "oh, you need to create a new
> gnome-terminal tab and launch firefox from that"?

Btw, most people don't do that anymore.  They don't use terminals.  They 
click the application icons on their desktops and start menus or double 
click the executables in their file managers.  So it's not a matter of 
opening a second terminal tab, because the first one isn't even open.

To have a fluid desktop one shouldn't require to hack with terminal 
commands.

