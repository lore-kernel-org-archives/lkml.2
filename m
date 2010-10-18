Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0JRRRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:17:31 -0400
Received: from fep33.mx.upcmail.net ([62.179.121.51]:33422 "EHLO
	fep33.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0JRRRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:17:30 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 13:17:29 EDT
X-SourceIP: 77.58.26.58
Message-ID: <4CBC7D57.8030209@odi.ch>
Date: Mon, 18 Oct 2010 19:01:11 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: xenoterracide@gmail.com
Subject: Re: repeated drive messages why?
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=xhnIrgVimuy9wQ+RkywzulFXCq7zNkI+ObDjxzBho7Y= c=1 sm=0 a=x8V-N2c3mDcA:10 a=8nJEP1OIZ-IA:10 a=-ut-hmoP8nqBekBacYQA:9 a=_hyqgRZQjmNuMhy8zPn1RFOOr7EA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> EXT4-fs (md1): re-mounted. Opts: commit=0

On my system this happens every time I switch from a terminal back to X. It
might be something in KDE/HAL that remounts the FS. Ugly but nothing to worry
about I think.

Ortwin

