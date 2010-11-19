Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0KSOr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:47:28 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62955 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab0KSOr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:47:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vi/WGlos3FiiatSt7wE2VsFmQO9vaGjJFLtmpMY4X12fGRuXr4P3OQr3J5CiQYnkFe
         l30IVxdHhEzDG6ZUxN+WZDxnI3aK1NlDIjtLGLcU6VGi1gB0cPAKp/ccql3rfm0aD1t9
         xej41+hwx527B89Z/KoERojaJksgGaLHMLMKM=
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
From: Namhyung Kim <namhyung@gmail.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com>
	 <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
	 <093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 23:47:14 +0900
Message-ID: <1290178034.1678.53.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-19 (금), 08:05 -0500, Theodore Tso:
> Oooh, I forgot another downside which just came to mind:
> 
> * Call of this code churn to fix whitespace all for the sake of keep
>  some damned checkpatch.pl script happy also breaks "git blame"
>  reports.
> 
> -- Ted
> 

Ah, agreed, it would be bad really. :(


-- 
Regards,
Namhyung Kim


