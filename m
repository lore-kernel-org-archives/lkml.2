Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2APNyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:54:53 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:46976 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2APNyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:54:52 -0500
Date: Mon, 16 Jan 2012 08:54:42 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Message-ID: <20120116135442.GA28487@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F142C28.001C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 04:28:47PM -0800, Andi Kleen wrote:
> Here's a slightly updated version of the BTRFS snappy interface.
> snappy is a faster compression algorithm that provides similar
> compression as LZO, but generally better performance.

Thanks Andi, I've queued this up to a btrfs snappy branch.  I put the
commits against 3.2 instead of 3.3 though so people could try it out.

The only problem I've hit is that snappy is failing xfstests number 135.
It's reproducible on an empty FS.  Could you please take a look?

-chris
