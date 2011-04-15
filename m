Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab1DOWSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:18:48 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:38853 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab1DOWSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:18:47 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=sOeZmqKXo9QeAvPHcA4bYEQFU2ce9l+aXDqfA8Y5Yr0= c=1 sm=1
 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17
 a=20KFwNOVAAAA:8 a=BOhMrgHjEJcJcAUfB2cA:9 a=CjuIK1q_8ugA:10
 a=jEp0ucaQiEUA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: Unionmount status?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
Date: Fri, 15 Apr 2011 16:18:43 -0600
Cc: Michal Suchanek <hramrach@centrum.cz>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com> <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com> <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com> <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com> <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-15, at 6:29 AM, Miklos Szeredi wrote:
> Apparently tmpfs does not support generic xattr.  I understand why
> tmpfs is an attractive choice for an upper filesystem, so this should
> be addressed.
> 
> I see two options here:
> 
> 1) implement generic xattr in tmpfs

There was a patch posted recently to add xattr support to tmpfs, so that it can use security labels:

From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] tmpfs: implement xattr support for the entire security namespace
Date: March 29, 2011 12:56:49 PM MDT

Cheers, Andreas





