Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0IEBCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:02:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55195 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0IEBCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xc3zohP9j9V468IODED5OTtiyU3SA0DW9Hh92xqB1aAcHYVuhGlfJMTF4CNYGi+vtp
         borclhaHnad51FchH3UeEw/mgXHmsv3KPwczDD5TftzT61gdAkpBtNKth0jXcK32kCtO
         1NUcTueG5D1PBX1B3RKTA6Elq2RaYjqU3ZND0=
Subject: Re: ldd scull_load question
From: runcoderen <runcoderzhcn@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100904174308.409c070e.rdunlap@xenotime.net>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
	 <201009020156.53803.konrad@darnok.org>
	 <1283455187.5598.86.camel@haakon2.linux-iscsi.org>
	 <1283644390.556.74.camel@haakon2.linux-iscsi.org>
	 <1283646914.1741.3.camel@bencharluo-laptop>
	 <20100904174308.409c070e.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 09:01:55 +0800
Message-ID: <1283648515.1741.8.camel@bencharluo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes, you do!

there is another question confused me.
I have seem the command in the scull.c:
int scull_major = SCULL_MAJOR;and so on.

module_param(scull_major, int, S_IRUGO); and so on.

if we don't do "./scull_load scull_major" command.

we just use "./scull_load"

it will make scull_major = SCULL_MAJOR default?

在 2010-09-04六的 17:43 -0700，Randy Dunlap写道：
> On Sun, 05 Sep 2010 08:35:14 +0800 runcoderen wrote:
> 
> > hi all:
> > I am reading ldd(3rd).
> > when I read the scull_load part.
> > I can't understand some special sentences in the scripts as follows:
> > 
> > /sbin/insmod ./$module.ko $* || exit 1
> > 
> > why we add $* and || exit 1 after /sbin/insmod ./$module.ko?
> > 
> > can anyone help me to understand?
> 
> "$*" passes all parameters of the script to the module as module parameters.
> 
> "insmod module.ko || exit 1"
> 
> means "if insmod is successful (no error), then the command is finished,
> otherwise exit with an error code of 1."
> 
> Does that help?
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 

/****************************************
http://runcoderen.wordpress.com
****************************************/

