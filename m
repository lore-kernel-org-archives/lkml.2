Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1CJBDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 20:03:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59069 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1CJBDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 20:03:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LVz87PV7dhVixVCPzMJtUvhbCDf/timTVFIw9O3gcCyAENK0OgRFu112CM2BhPSuLl
         mM2bHHVD5ZQP971pP/TZrzzsvtRZ1avS6mYqLum7pEmyGjze8J8Z2MSAbfHSBj36yBtr
         yNpaDYJN2HRwJ/Oy/KkatDftLmrUtRvuLKRc4=
MIME-Version: 1.0
In-Reply-To: <20110310114315.eb9aec89.sfr@canb.auug.org.au>
References: <20110310114315.eb9aec89.sfr@canb.auug.org.au>
Date: Wed, 9 Mar 2011 19:03:09 -0600
Message-ID: <AANLkTim72ezchng-hks10HvQOjB_yk1_8x7xYZ+DVZox@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed in cifs-2.6.git now. Trivial.   Shirish missed an ifdef.


On Wed, Mar 9, 2011 at 6:43 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> ERROR: ".set_cifs_acl" [fs/cifs/cifs.ko] undefined!
>
> Caused by commit 30091b5571eb ("cifs: Allow to set extended attribute
> cifs_acl (try #2)").
>
> I have used the cifs tree from next-20110309 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Thanks,

Steve
