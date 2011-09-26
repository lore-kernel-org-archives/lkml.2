Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1IZVFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:05:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:58287 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1IZVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:05:08 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arun <engineerarun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Detection of Advanced Format drives
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
Date: Mon, 26 Sep 2011 17:03:05 -0400
In-Reply-To: <20110926111522.2a053ceb@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 26 Sep 2011 11:15:22 +0100")
Message-ID: <yq1aa9rf246.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4E80E8FC.00F7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Is there any way to detect the Advanced Format hard drives with 4K
>> sector size? I understand that above kernel v. 2.6.31 it is
>> supported.  But is it possible detect automatically if the drive is
>> an AF drive and how?

Alan> It's in the drive identify data (see the ATA 8 specification
Alan> documents)

Or:

  http://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf

-- 
Martin K. Petersen	Oracle Linux Engineering
