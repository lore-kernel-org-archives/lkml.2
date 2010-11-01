Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0KATGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:06:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57152 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0KATGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YMC5Ip1RNi/rNbprq7CCYrZlXi9HBZowKD2tFd55hxu1x1PlX3nJWVRt1nQ0J6tI/d
         NGrJBGpAGLx6TO7F0eAvQd3ZjBtChydptcurlkdw177rTRow0MjRAcXGlGs2OT8M7RrD
         ueP34ythBvRBRQsvi+GF8/JILt9bUfwhUeB4M=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 21:06:04 +0200
X-Google-Sender-Auth: 9D7ccQTCioeRTVhc5zk2RGrOkiA
Message-ID: <AANLkTikT5TyCL-rRMQ31_86_SbYH+odoppQh-tovsEBZ@mail.gmail.com>
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
From: Pekka Enberg <penberg@kernel.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> The patch sets puts the yaffs2 filesystem in the staging directory.
> It is all based on Charles git tree(http://github.com/cdhmanning/linux-yaffs-integration/).
> Everything is compile tested and it builds.
>
> This only the inital support and I will be sending more cleanup patches.
>
> Greg can you add the patch set into your staging-next tree.
> Also, It doesn't affect anything other than itself.

I know Greg is happy to take this in but it would also be interesting
to know what's the benefit of YAFFS2 over existing filesystems.
