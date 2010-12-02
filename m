Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0LBTUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:20:23 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:55341 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757095Ab0LBTUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:20:22 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH 1/8] Add yaffs2 file system: allocator, attribs, bitmap code
Date: Fri, 3 Dec 2010 08:20:18 +1300
User-Agent: KMail/1.9.10
Cc: Charles Manning <cdhmanning@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-2-git-send-email-cdhmanning@gmail.com> <20101202181344.GA2853@joi.lan>
In-Reply-To: <20101202181344.GA2853@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012030820.18321.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 December 2010 07:14:04 Marcin Slusarz wrote:
> On Wed, Dec 01, 2010 at 10:57:27AM +1300, Charles Manning wrote:
> > +void yaffs_load_current_time(struct yaffs_obj *obj, int do_a, int do_c)
> > +{
> > +	obj->yst_mtime = Y_CURRENT_TIME;
>
>                  ^
>
> > +	if (do_a)
> > +		obj->yst_atime = obj->yst_atime;
>
>                          ^                ^
>
> > +	if (do_c)
> > +		obj->yst_ctime = obj->yst_atime;
>
>                          ^                ^
>
> > +}
> > +
>
> Funny bug.

Thanks.

I shall fix this in yaffs git right away.

The power of open source!
