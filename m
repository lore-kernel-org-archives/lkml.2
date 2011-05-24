Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab1EXBrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:47:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1EXBrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=efKr/q97bQ+H1m7d4NXJU+Wj/tNdGfaCMJByGgdpKwY+hfuusqQ8KP10YKmMbYuP1p
         xOCbln0yKWGnUw9uce0npafXNUspFwf2Gqy6FwpIwKhv3TRkPSUNpx8yuQSk9noqCXDg
         Oyz9kFebZo06oQqerI8VNRhd/vXblrU9TuAxI=
MIME-Version: 1.0
In-Reply-To: <20110403234402.GC1420@mtj.dyndns.org>
References: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
 <1301696134-31249-1-git-send-email-vapier@gentoo.org> <20110403234402.GC1420@mtj.dyndns.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 23 May 2011 21:46:53 -0400
X-Google-Sender-Auth: iut8mP9-zPFzoRn8pMNTqsMMakk
Message-ID: <BANLkTikaJuw9WE-87cNkh1UQPgyP3mokVg@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 1/2 v2] percpu: unify input section names
To: Tejun Heo <tj@kernel.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 3, 2011 at 19:44, Tejun Heo wrote:
> On Fri, Apr 01, 2011 at 06:15:34PM -0400, Mike Frysinger wrote:
>> The two percpu helper macros have the section names duplicated.  So create
>> a new define to merge the two.  This also allows arches who need to link
>> things more directly themselves to avoid duplicating the input sections in
>> their linker script.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Applied to percpu#fixes-2.6.39.  I'll push the branch to Linus
> soonish.  It is a stable branch so please feel free to pull from it if
> necessary.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git fixes-2.6.39

i dont see this in mainline for 2.6.40-rc1 either ?
-mike
