Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2DGV1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 17:27:18 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:35959 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab2DGV1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 17:27:17 -0400
Date: Sat, 7 Apr 2012 17:27:05 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Message-ID: <20120407212705.GD11295@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
References: <4F80892A.7050104@zytor.com>
 <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2012 at 01:02:33PM -0700, H. Peter Anvin wrote:
> The problem is that the lack of migration at the root causes real
> problems for the people who need the extra funkiness, and unlike BSD
> ttys it's not an application-level change at all.

Could you explain what the issues are?  I haven't been following
devpts all that carefully.

Thanks,

						- Ted
