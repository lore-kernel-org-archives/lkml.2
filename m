Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1C2V1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:27:46 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:57908 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1C2V1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dlTBeTGCvl+XIk1tXtaly6EGyawUl4r0eNFIEZa3Ei9Eh8KTst5CZgvCPTlM+Zh8KC
         aMYTOooSp17Si0s5cPxV85MXluHWrQAEOwYnPDCjfNIoIe+evZorhsNC1Ymmkr/3XkAe
         bgCtNAD4fF5hnwJ1R1YCZGGPE0xK1B0BGeQ3Q=
MIME-Version: 1.0
In-Reply-To: <20110304173528.60c04f76.randy.dunlap@oracle.com>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
	<20110304173528.60c04f76.randy.dunlap@oracle.com>
Date: Wed, 30 Mar 2011 01:27:44 +0400
Message-ID: <AANLkTinhKKtPS7-tFcoU8JE=zsgikEn979DemyXX8q_z@mail.gmail.com>
Subject: Re: [PATCH -next] staging: altera-jtag needs delay.h
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 March 2011 04:35, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> altera-jtag.c needs to include <linux/delay.h> to fix a build error:
>
> drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Igor M. Liplianin <liplianin@netup.ru>

Mauro, Greg. 2.6.39 still needs this fix.
