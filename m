Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0IEAfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 20:35:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58529 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0IEAfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 20:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=RM5ZVwBrDt9n2KmaO0e8vtWlULOZFLsjTxzeFIKbwb9zsAHKz8s4siwDt+TyexN/RT
         B3cqhii7Ske3WcDJ30dJbUfjKJS5HVvZWFbfKzjyt61vHPkFa0rOJa+Df2s59O/Z5YA1
         KRMgCGjwUnzR5fWbZgEiYqJnZU85HfahOYF/w=
Subject: ldd scull_load question
From: runcoderen <runcoderzhcn@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1283644390.556.74.camel@haakon2.linux-iscsi.org>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
	 <201009020156.53803.konrad@darnok.org>
	 <1283455187.5598.86.camel@haakon2.linux-iscsi.org>
	 <1283644390.556.74.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 08:35:14 +0800
Message-ID: <1283646914.1741.3.camel@bencharluo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:
I am reading ldd(3rd).
when I read the scull_load part.
I can't understand some special sentences in the scripts as follows:

/sbin/insmod ./$module.ko $* || exit 1

why we add $* and || exit 1 after /sbin/insmod ./$module.ko?

can anyone help me to understand?

		runcoderen

-- 

/****************************************
http://runcoderen.wordpress.com
****************************************/

