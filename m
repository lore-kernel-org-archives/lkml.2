Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2GTKOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:14:12 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1983 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2GTKOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:14:10 -0400
Message-ID: <1342779242.26179.65.camel@x61.thuisdomein>
Subject: Re: [PATCH] [TRIVIAL] treewide: fix four odd angle bracket includes
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Date: Fri, 20 Jul 2012 12:14:02 +0200
In-Reply-To: <alpine.LNX.2.00.1207201026490.21929@pobox.suse.cz>
References: <1341006775.1911.59.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1207201026490.21929@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Jul 2012 10:14:08.0304 (UTC) FILETIME=[66503B00:01CD6660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 10:28 +0200, Jiri Kosina wrote:
> Right, but ... I don't really see the value of switching either way, do 
> you?

0) Sure I do, that's why I submitted this trivial patch in the first
place.

1) As I mentioned in the patch explanation: why bother using angle
brackets if one is actually including a header outside of the include
search patch?

2) It's unobvious to start the paths of a header in an angle bracket
include with "..". At least, it took me a while to figure out what these
four includes were actually doing, simply because they're rather odd.
(There are over 100000 angle bracket includes, and exactly four that
start with "..".)

3) To me this trivial patch is comparable to trivial patches I submitted
recently concerning other odd includes. In your for-next branch we now
have commit 6ac7d11527a31d01b566a5c45369180e326ff4f1 ("treewide: Put a
space between #include and FILE"), and commit
cc502bb741e1797290381da14dddb695ec1adbaf ("renesas_usbhs: cleanup quoted
includes"), and one similar commit. These all change includes that are
perfectly legal but a bit odd. And that makes these includes a bit
harder to understand, to git grep for, and to handle correctly in the
kind of scripts I use to find certain issues in the tree.


Paul Bolle

