Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827Ab0GJEdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 00:33:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56123 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab0GJEdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 00:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IxKmOtn20FasHvs85JEyXYUyaSSAphElurLlmI0Ghrf7q8UPEEp/bW9W7DW1D6Jzc7
         u/ogtOZ6KEx74/LUMSBvx+ExNztEBmoHn0VyryMnvNakxU6WFTxBvXxZIEPm1xeuazV7
         oFrZrFSDIC0a8aQ9BY2d1MQ5skgjkGQDM1d2E=
Subject: Re: [PATCH 0/1] VFS: introduce s_dirty accessors
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100709153146.fc7d1a6b.akpm@linux-foundation.org>
References: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
	 <1278335067.29620.51.camel@localhost> <20100709222737.GB27019@thunk.org>
	 <20100709153146.fc7d1a6b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jul 2010 07:33:32 +0300
Message-Id: <1278736412.7365.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 9 Jul 2010 18:27:37 -0400
> tytso@mit.edu wrote:
> this:
> 
> : commit 140236b4b1c749c9b795ea3d11558a0eb5a3a080
> : Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> : Date:   Thu Jun 10 13:56:33 2010 +0300
> : 
> :     VFS: introduce s_dirty accessors
> 
> was merged into mainline a few days ago?

Yeah, it was merged. Now I'm patiently waiting for Al's response for the
rest.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

