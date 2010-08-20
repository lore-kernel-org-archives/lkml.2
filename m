Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab0HTWSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:18:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33365 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0HTWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=xNsG112tIQpEXRzQn7O0TBNK5FR144ThjVEXanTmsPyx58ckJXbeqEOx545bC/tUOJ
         zgPL5kvJl//fRW8XmKssRQTV6hW/x/+psEgK2Mv0pJWfY0SERqFmPVWwcIQKQ4IIp9YG
         22foYtuXVESTxMEjj7A7hbfvT7iM+2CM5JH0A=
Subject: sys_init_module system call
From: runcoderen <runcoderzhcn@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100820221323.GC8535@lixom.net>
References: <20100818041333.GA14149@lixom.net>
	 <20100818171636.0625b668.akpm@linux-foundation.org>
	 <20100819032230.GA21980@lixom.net> <20100820010242.GA29588@lixom.net>
	 <20100820221323.GC8535@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 06:18:04 +0800
Message-ID: <1282342684.1631.4.camel@bencharluo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all
I find sys_init_module system call in kernel/module.c file.
but it did not find any.
the source code version is linux-2.6.35

does the kernel have changed?

the book I am reading is LDD 3rd edition

-- 

/****************************************
http://runcoderen.wordpress.com/
****************************************/

