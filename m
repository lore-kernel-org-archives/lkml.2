Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546Ab2AFSqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:46:21 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49710 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab2AFSqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:46:19 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=oQE6vNJ3d7oTBHj4PDKYH99BAdyPlqTp0xAtaaBYR4E= c=1 sm=1
 a=yzVfIOMwy8YA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=VwQbUJbxAAAA:8 a=g-JwlV_RxiMNuOAZZ58A:9
 a=CjuIK1q_8ugA:10 a=U62fhAwekXMA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH v2.2 00/23] ext4: Add metadata checksumming
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20111214013158.GB8233@tux1.beaverton.ibm.com>
Date: Fri, 6 Jan 2012 11:46:17 -0700
Cc: Theodore Tso <tytso@mit.edu>, Sunil Mushran <sunil.mushran@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel Devel <linux-fsdevel@vger.kernel.org>,
        ext4 development <linux-ext4@vger.kernel.org>,
        Coly Li <colyli@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <816F9C6C-51E4-4CB2-84F7-762EC10CB282@dilger.ca>
References: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com> <20111214011028.GA8233@tux1.beaverton.ibm.com> <20111214013158.GB8233@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 04:46:14PM -0800, Darrick J. Wong wrote:
> This patchset has been tested on 3.2.0-rc5 on x64, i386, ppc64, and ppc32.
> The patches seems to work fine on all four platforms.
[snip]
> --D
> 
> [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

This URL is broken due to the kernel.org rebuild, so if it is going into
Git it should be updated to the new URL:

https://ext4.wiki.kernel.org/articles/e/x/t/Ext4_Metadata_Checksums_4d24.html

Cheers, Andreas





