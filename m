Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0FHMoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:44:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:27979 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0FHMoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=qh/G7CtJmKuAAqrpt/dZ1wCh8A7yqVEKRbvkXH3apB7Bxp+6k2Lqt1K0kUD8Ufaiw2
         lQLLcvh+MThUgDar/LxB0U4gJlp/59OUnj3G+9taWwy1ZPsNxsjEua6tdXV0MtpMPvyi
         GVhSbQpHvTwbKgvuVzT4qPY+ArauQelPD8fYQ=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.18-rc1
Date: Tue, 8 Jun 2010 14:43:58 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-00001-g386f40c; KDE/4.4.4; x86_64; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>, Karel Zak <kzak@redhat.com>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
References: <20100608104618.GA18342@nb.net.home> <E1OLwWP-0003Wp-ST@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OLwWP-0003Wp-ST@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006081443.59559.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 of June 2010, Miklos Szeredi wrote:
> On Tue, 8 Jun 2010, Karel Zak wrote:
> > umount(8):
> >   - supports new command line option "-f/--fake" to avoid umount(2)
> >   syscall
> 
> I think you just mean "--fake",  -f is --force.

It's usually called --dry-run, --fake is uncommon.

> Thanks,
> Miklos

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
