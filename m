Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab2EILVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:21:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab2EILVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:21:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] serial8250-em: Add DT support
Date: Wed, 9 May 2012 11:21:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-serial@vger.kernel.org, horms@verge.net.au, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        dan.j.williams@intel.com, alan@linux.intel.com
References: <20120509065514.18528.83245.sendpatchset@w520>
In-Reply-To: <20120509065514.18528.83245.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091121.38313.arnd@arndb.de>
X-Provags-ID: V02:K0:f+zROg400LX/K25iGt5oexoVSqohOX+qX9HtKJ1lmq1
 5Ur84HOmjA05nUtbNNfvf0JVKVgUFaOUKF5msrk77X27TyZXVP
 mm3kyheoAh1On813x2bkT0YA8tutNPq3tb1HKapf+pBlkhxJwF
 DQYhxCeQ+55EaWIXwaCzwx+3NuT4hIcXs12RTOhO1kDJPBJHDt
 XJCBlunUKb3O6mdMxodpGOInbrenW9cbSMQrGoM6atn/6Tr9cm
 gck7uAEdOjN89q5OvMt6uBeE1jb2uCQo/d6Q5qNJcDGFmhUCNA
 KwiZzjYft0yc8loWNTzcOf5m2wWfUUC4sT6f3GeHxCTCVgQVnB
 QGivTSTTtlWwhdUBMDLg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Magnus Damm wrote:
> 
> From: Magnus Damm <damm@opensource.se>
> 
> Update the 8250_em driver to support DT.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Arnd Bergmann <arnd@arndb.de>
