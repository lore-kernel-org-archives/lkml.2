Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1FWNR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:17:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab1FWNRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ImitLUehCErhz4cEDuJLsDdWllxA4PMKril4mTmM1d5U6eT74+H2Mg8PbVx7TnKgd7
         gMlNg1pQfPLOYjsUTWsdZ59tB+epDTvQsIU1abHwLVegWPzo8819nROopFFtzk+xm8UN
         vOqg685WlcdLTQbwKK9++lEi00zpBYofzX+3I=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
Date: Thu, 23 Jun 2011 15:17:54 +0200
Message-ID: <BANLkTinaPJM3LhEVwFxtEGKuVXOyVOzrzg@mail.gmail.com>
Subject: Re: extra slash in current path
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: yuyichao-mit <yuyichao@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 3:14 PM, yuyichao-mit <yuyichao@mit.edu> wrote:
> The problem is like this:
>
> $ cd /
> $ pwd
> /
>
> $ cd /
> $ pwd
> //
>
> $ cd ///
> $ pwd
> /
>
> Why can there be a extra slash (and exactly one) in current path? Is
> this designed on purpose?
> This is not really a big deal but I think it can confuse some program.

Multiple consecutive slashes should not confuse any program.

http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_266

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
