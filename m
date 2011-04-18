Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1DREXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 00:23:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1DREXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 00:23:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH 1/1] drivers/usb/image/mdc800.c: Remove "typdef enum".
Date: Mon, 18 Apr 2011 06:22:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: wanlong.gao@gmail.com, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org
References: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com> <BANLkTikDtpg2CKM_Rq9hZ44F4jHvM3bOdg@mail.gmail.com> <BANLkTinFYjtOQbcdrDBNODrzjtU-VDuNxQ@mail.gmail.com>
In-Reply-To: <BANLkTinFYjtOQbcdrDBNODrzjtU-VDuNxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104180622.53412.arnd@arndb.de>
X-Provags-ID: V02:K0:ZaQaB4CRGEKTiWMk1NbQw0mhI3yyf2HqYES7uHawZI6
 BjGF6uxZXWGx/zHXBPPAi1Vp8HhbPl3BcOxMQLh1vh12IbKMIi
 0iREU4zXTYpE0lekwoY+Ild28hz8KJYGBOWCAz6HMDAuI5GkfH
 vZzcfdbFFragzW3AMJHGEZCKtiQe1113jUJk0FKSBIm76oW8uH
 sZcIEVTmj1VVdj2fw4Rmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Thiago Farina wrote:

> > and why change so many lines ?
> 
> Removed whitespaces, and converted // to /* */

You forgot to list these in the changelog.

	Arnd
