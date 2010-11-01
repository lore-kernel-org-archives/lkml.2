Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab0KATOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:14:41 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:60723 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750954Ab0KATOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:14:40 -0400
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
Date: Tue, 2 Nov 2010 08:14:35 +1300
User-Agent: KMail/1.9.10
Cc: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <4CCF0D2B.6070308@caviumnetworks.com>
In-Reply-To: <4CCF0D2B.6070308@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011020814.35902.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 November 2010 07:55:39 David Daney wrote:
> On 11/01/2010 11:40 AM, Tracey Dent wrote:
> > The patch sets puts the yaffs2 filesystem in the staging directory.
> > It is all based on Charles git
> > tree(http://github.com/cdhmanning/linux-yaffs-integration/). Everything
> > is compile tested and it builds.
> >
> > This only the inital support and I will be sending more cleanup patches.
> >
> > Greg can you add the patch set into your staging-next tree.
> > Also, It doesn't affect anything other than itself.
> >
> > Thanks,
> >
> > Tracey Dent
>
> I am confused.
>
> Are you and Charles Manning working together on this?
>
> Did you write all this code or did Charles?  If it was Charles, why are
> there no From: and Signed-off-by headers for him?
>
> Thanks in advance for enlightening us as to what is going on here,
> David Daney

We are not working together on this, but I do appreciate the effort in helping 
bring to a head what people like/dislike.

I am trying to keep the kernel yaffs consistent with the yaffs.net yaffs so 
that it is easier to add changes from yaffs.net.

-- Charles

