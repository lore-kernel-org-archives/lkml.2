Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab0JHIza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:55:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45617 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab0JHIz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=htjWVn7/4W18/sVdmgSunAuOaJ+UMb5xEdBIqmi6e67HRkXJ3S3F4ipfsYcI4qoUrM
         XL8u06CEbm2hKVNivOKhhxhY7vtpkPv8cTACkaDmBvJXjTUA+mleLDac6or+v8r7keEn
         aoggIu/h1d6DP10K8tW3aDgOLjX3OKLFbkYag=
Date: Fri, 8 Oct 2010 10:55:09 +0200
From: Dan Carpenter <error27@gmail.com>
To: matt mooney <mfmooney@gmail.com>
Cc: T Dent <tdent48227@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 00/33] Staging: Fixed <module-objs> to <module>-y
Message-ID: <20101008085508.GG11681@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	matt mooney <mfmooney@gmail.com>, T Dent <tdent48227@gmail.com>,
	greg@kroah.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, sam@ravnborg.org,
	linux-kbuild@vger.kernel.org
References: <AANLkTi=Hc2eWzOQ_xKBYsqfwkkiKGU0v42jUhLQ8K7dU@mail.gmail.com> <AANLkTinynZj9bYFAyfRTF2uopmLe6Ls4YGdZPqCAJTpR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinynZj9bYFAyfRTF2uopmLe6Ls4YGdZPqCAJTpR@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 12:16:35AM -0700, matt mooney wrote:
> On Thu, Oct 7, 2010 at 6:35 PM, T Dent <tdent48227@gmail.com> wrote:
> > I patch against the next-20101006 tree.
> >
> > The patch series replace use of <module>-objs with <module>-y in the
> > staging directory.
> 
> Commit messages are written in the present tense. You happen to be
> using two different tenses within the commit message, which is truly
> odd.

Maybe *you* write in the present tense.  Commit messages are important,
yes, but this in the end we all understood the message fine.  Please
don't be a jerk.

regards,
dan carpenter

