Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1AFOFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:05:02 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37994 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab1AFOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:05:01 -0500
X-Sasl-enc: KEaaRQyxG2guns2t2y9+DrRZhVOy9jeZtsXzysWvq8wG 1294322699
Subject: Re: [autofs] Autofs SMBFS no write in files
From: Ian Kent <raven@themaw.net>
To: Issa <frechdesign@gmail.com>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4D1A31B2.4000103@gmail.Com>
References: <alpine.LNX.2.00.1012122357570.9206@swampdragon.chaosbits.net>
	 <1292382195.2979.17.camel@perseus>
	 <alpine.LNX.2.00.1012171306310.4638@swampdragon.chaosbits.net>
	 <4D1A31B2.4000103@gmail.Com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 22:04:53 +0800
Message-ID: <1294322693.2852.2.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-28 at 19:51 +0100, Issa wrote:
> Hello,
> 
> 
> Autofs accés smbfs impossible d'écrire sur le disque ?
> Autofs smbfs no writing ?

A bit off topic but is there some reason you need to use smbfs.
It's deprecated and I expect it will go away some time soon.
You should try using CIFS if you have a reasonably recent (or even not
so recent should be ok) kernel.

> 
> Im usint autofs with ubuntu 10.10
> Im using autofs like this
> 
> 
> sudo nano /etc/auto.master
> 
> 
> +auto.master
> /mnt/smb       /etc/auto.auto   --timeout=60 --ghost
> et le fichier sudo nano /etc/auto.auto
> 
> 
> #directory name         option for mount                                                  device to mount
> win1            -fstype=smbfs,rw,credentials=/etc/smb.auth         ://win1/docs/
> Authentication files :
> sudo nano /etc/smb.auth
> 
> 
> username=users1
> password=motDePasse
> domain=windowsDomaine
> 
> now with this i can access only in read
> /mnt/smb/win1
> 
> My question how add acess to write ?
> 
> 
> because i can write for the moment.
> 
> 
> thanks
> 
> 
> _______________________________________________
> autofs mailing list
> autofs@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/autofs


