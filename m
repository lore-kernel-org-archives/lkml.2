Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0KATiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:38:15 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:60961 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751661Ab0KATiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:38:13 -0400
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 29/29] Staging: yaffs2: TODO: Add TODO file
Date: Tue, 2 Nov 2010 08:38:09 +1300
User-Agent: KMail/1.9.10
Cc: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-30-git-send-email-tdent48227@gmail.com> <AANLkTinN5ti5T_PnuvfoSXomGR6CKkKU2_fgo8g3urL+@mail.gmail.com>
In-Reply-To: <AANLkTinN5ti5T_PnuvfoSXomGR6CKkKU2_fgo8g3urL+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011020838.09417.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 November 2010 08:20:27 Pekka Enberg wrote:
> On Mon, Nov 1, 2010 at 8:41 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> > Inital TODO file.
> >
> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > ---
> >  drivers/staging/yaffs2/TODO |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/staging/yaffs2/TODO
> >
> > diff --git a/drivers/staging/yaffs2/TODO b/drivers/staging/yaffs2/TODO
> > new file mode 100644
> > index 0000000..be6a836
> > --- /dev/null
> > +++ b/drivers/staging/yaffs2/TODO
> > @@ -0,0 +1,6 @@
> > +TODO :
> > +
> > +       * checkpatch.pl fixes
> > +       * sparse fixes
>
>  * drop typedefs
>  * drop Linux kernel version compatibility macros
>  * drop other strange compatibility macros
>  * fix formatting with Lindent

I am in the process of making up a new patch set for release within 24 hours 
that does the following:

* drops typedefs
* drops the last few camel case names
* replaces __u32 with u32 etc
* drops few remaining kernel version compatibility macros.
* cleans up #if 0 code
* clean up some of the headers etc reported today.

It is my goal to keep the code portable which is going to be a bit of a 
challenge, but I want to at least make an effort to do this.

Thanks to all for their comments etc. I appreciate the effort.

I shall be pushing this to git as well as sending out patches.


-- CHarles





