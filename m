Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab0HKEXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 00:23:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64038 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0HKEXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 00:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mB9IsMVU2TdxfkRk8VUGU0JXIoNlp4lOqlWjQx2E54NuBtFk+ybp2H93Y/G3lB2j7H
         og2nWogyu20BifGIJZrQSeKm/qF8jK2805FsxCCJ9C2OHqEF4LSlmzmG93whylct/t2u
         oQSZAS/A01QDBFCEtmfETwTDgL2nyz9GUUKCE=
Date: Wed, 11 Aug 2010 12:27:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compile one file in kernel
Message-ID: <20100811042722.GA5604@cr0.nay.redhat.com>
References: <14414B36FFA0F1418CB707361EAA199A01987DD6@CNBEEXC006.nsn-intra.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14414B36FFA0F1418CB707361EAA199A01987DD6@CNBEEXC006.nsn-intra.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 08:59:06AM +0800, Zhang, Wei-Jovi (NSN - CN/Hangzhou) wrote:
>Hi,
>	I always using command make, then it will compile all files. How
>about just compile one c file(just make sure some modify can compile
>successful), how should I do? Is there any command to allow me to doing
>this?


You can always find these info in `make help`:

...
  dir/            - Build all files in dir and below
  dir/file.[oisS] - Build specified target only
  dir/file.lst    - Build specified mixed source/assembly target only
                    (requires a recent binutils and recent build (System.map))
  dir/file.ko     - Build module including final link
...
