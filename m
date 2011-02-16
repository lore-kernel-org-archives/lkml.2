Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1BPQXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:23:50 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49290 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1BPQXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=o5Jq4SWCY8QyYQLcjapjydJOGLsAQ4YWFYOD1gsMwZchrwUH0eIsut972rm5iXoyKh
         OPVaNyoYlyqNjuDiDUb7QKUqon5ENaUkcV8JVNKnxhZgM5kdMt8mmSHzIjirzmCfBVQk
         lOw9u40QYpQVDja7+mY6aUZgXhaQTHsnT7fgs=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: akpm@linux-foundation.org
Subject: Regression with dataloss: Reiserfs deadlock in 2.6.36 and 2.6.37, know working 2.6.33
Date: Wed, 16 Feb 2011 17:22:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com> <20101223034229.GF1739@nowhere> <201101300108.32383.roucaries.bastien@gmail.com>
In-Reply-To: <201101300108.32383.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102161722.24963.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 30 janvier 2011 01:08:29, Bastien ROUCARIES a écrit :
> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
> Hi,
> 
Dear Andrew,

Since three month I suffer fo regular dataloss in reiserfs kernel. I have posted all the detail  on #29162 under bugzilla.

This bug freeze my notebook every hour between 6 hours. using git pull and compiling kernel seems to exercice this bugs.

Frederic is really busy by academic millestones and I really thank him for his previous help, do you know somebody willing to 
help?

I could test some patch if needed.

Thank you

Bastien
