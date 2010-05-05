Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572Ab0EEPU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:20:59 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:49415 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760442Ab0EEPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xFdIxlFfQddmTOAqgfGCSp+VlTE9rvjmxTUPwHemElwCjHT9D69620ccbtiuZi3/Ip
         LoK+HCOdMUH+ckenGO3Qrnm6dUTqYnwymXemPLp95gGyI/t1VgxSyIoUhpw54qqW8AHY
         uuU98LhdQ7A7DkLK9wHrPNdp0J89aWG1XpiDI=
MIME-Version: 1.0
In-Reply-To: <4BE11FA0.20703@parrot.com>
References: <17c88de31cd52bb3794569c28cd2ae51996e6260@localhost.localdomain>
	 <10137ab89de6e6d229798d6f397688b0807024da@localhost.localdomain>
	 <4BE11FA0.20703@parrot.com>
Date: Wed, 5 May 2010 08:20:53 -0700
Message-ID: <w2y347733d51005050820obdcea4e7k7564550723ef7c24@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] mtd: nand: Extend NAND flash detection to new MLC 
	chips
From: Kevin Cernekee <cernekee@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Reuben.Dowle@navico.com" <Reuben.Dowle@navico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 12:34 AM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> Doesn't these nand support ONFI "Read Parameter Page" (cmd 0xec) ?
> If yes it will be a more generic way to detect new nand features.

Unfortunately, Samsung and Toshiba do not support ONFI:

http://onfi.org/membership/

http://www.hantat.com/News-Read-281-1.html
