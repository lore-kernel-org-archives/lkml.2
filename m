Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0EDO0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:26:10 -0400
Received: from smtp.nokia.com ([192.100.122.230]:23854 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab0EDO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:26:08 -0400
Subject: Re: [PATCH v2] mtd: Do not corrupt backing device of device node
 inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       David Woodhouse <dwmw2@infradead.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100504111947.GB3398@quack.suse.cz>
References: <1272922368-18517-1-git-send-email-kirill@shutemov.name>
	 <20100504111947.GB3398@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 17:19:17 +0300
Message-ID: <1272982757.3702.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 May 2010 14:25:25.0294 (UTC) FILETIME=[A32054E0:01CAEB95]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 13:19 +0200, Jan Kara wrote:
> On Tue 04-05-10 00:32:48, Kirill A. Shutemov wrote:
> > We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> > backing device of device node inode, since file->f_mapping is equal to
> > inode->i_mapping (see __dentry_open() in fs/open.c).
> > 
> > Let's introduce separate inode for MTD device with appropriate backing
> > device.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
>   The patch now looks correct to me. Acked-by: Jan Kara <jack@suse.cz>
> 

Is this -stable material?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

