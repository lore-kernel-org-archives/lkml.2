Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1C2L7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:59:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab1C2L7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:59:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: Warning with asm-generic/div64.h
Date: Tue, 29 Mar 2011 13:58:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Len Brown'" <len.brown@intel.com>, "'Pavel Machek'" <pavel@ucw.cz>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        linux-pm@lists.linux-foundation.org
References: <007801cbead6$1984b6e0$4c8e24a0$@mprc.pku.edu.cn> <201103251439.53568.arnd@arndb.de> <018a01cbee06$534730a0$f9d591e0$@mprc.pku.edu.cn>
In-Reply-To: <018a01cbee06$534730a0$f9d591e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291358.56758.arnd@arndb.de>
X-Provags-ID: V02:K0:Ailn47InBciZ+kxUKMSc07DJu4NShKuY8KxCO5yMwXY
 1QJHFi3qTEsbVtUnM1gWUWmqlcnx2MwMkdthH7NMYW0kLyq9BC
 mLP3tvZLf6nBgETowVJm2xi0oPBAsG0AVbCNK9biKdop7wR23S
 6TmvXqHPOlDu6G+sePzO9YN4KaSlCondy0FpKIT2eXdP88yuRu
 ard+a2nF6JvJUlP57dCAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011, Guan Xuetao wrote:
> > The macro doesn't work for signed input or for 32 bit input. I'd suggest
> > fixing the caller to use an unsigned type.
> 
> Then,
> Cc: Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM)
> Cc: Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
> Cc: linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)

Yes, that sounds right.

	Arnd
