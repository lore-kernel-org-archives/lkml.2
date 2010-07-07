Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0GGMpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:45:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44827 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0GGMpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:45:09 -0400
To: Neil Brown <neilb@suse.de>
CC: david@fromorbit.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <20100707125726.3695587a@notabene.brown> (message from Neil Brown
	on Wed, 7 Jul 2010 12:57:26 +1000)
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<871vbn2mk9.fsf@linux.vnet.ibm.com>
	<20100702064108.64034561@notabene.brown>
	<87iq4y29a6.fsf@linux.vnet.ibm.com>
	<20100706161002.GD7387@fieldses.org>
	<87eifgfsez.fsf@linux.vnet.ibm.com>
	<20100706232351.GD25018@dastard>
	<20100707093629.10c2feab@notabene.brown>
	<20100707021150.GF25018@dastard> <20100707125726.3695587a@notabene.brown>
Message-Id: <E1OWTzA-00047n-JV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Jul 2010 14:44:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010, Neil Brown wrote:
> The trouble with /proc/mounts is that it is somewhat clumsy to parse
> (remember to handle \0ctal escapes) and doesn't include major/minor number

/proc/self/mountinfo does.  And it's extensible, just add an
"uuid:123" before the dash.

Thanks,
Miklos
