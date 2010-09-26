Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0IZKzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 06:55:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab0IZKzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 06:55:54 -0400
From: "Martin Rogge" <marogge@onlinehome.de>
To: linux-kernel@vger.kernel.org
Subject: Re: no modules :-)
Date: Sun, 26 Sep 2010 12:55:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4; KDE/4.5.1; x86_64; ; )
Cc: bjlockie@lockie.ca
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009261255.51913.marogge@onlinehome.de>
X-Provags-ID: V02:K0:wM6QhJ2FwouDf/389AXKhbk0MJrXkRnBJxH8/nm5kyY
 ynIax+LGbFE/BfX0SSJBZsSELZq8j/y+AsVws11QqpGUkgfk6l
 BV6/ZlRbvCKV1CgXLJat9iNmxil8fZL1puGzzQ8sqQ85/STKo5
 NKc3+nXAByTcJIBbJaRE30XNLGEsK1wm0LFeZIaE8+BIMOr1QT
 Unxk4jNOAZFfBGeSezWfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James wrote:
> I don't like modules. :-)
> 
> What is pulling this in:
> 
> CONFIG_SCSI_WAIT_SCAN=m
> 
> I edited .config but make must have turned it back on.

It has been doing this for years (forcing itself upon you as soon as you 
enable the MODULES & SCSI options). It is the only module doing that. 

I consider the behaviour broken since it takes the option away from me to have 
a static kernel with only third party software as modules. But it is no big 
issue.

Martin
