Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1D3GOE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 02:14:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53117 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1D3GN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 02:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=BnHJUHrARrMZQGTKr3Yx7DO7hPmPpC98ZLkkWUg2vob+JFbnY+ptpNKlcx0IrDuB5X
         CjhB+9mVQa1ry5fdqb7+qx4EuTeBfHGG0o1PlOtRWxY8pGoIHNB+MUw2wPkZs7reqBlT
         63mFdBVk1jnuF/6XW+hkD7AxZ6jd7C9ilazrY=
Date: Sat, 30 Apr 2011 14:13:39 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, joe@perches.com,
        randy.dunlap@oracle.com, trivial@kernel.org
Subject: [Oops 1/2]Something wrong with copy_from_user() function
Message-ID: <20110430061336.GA4274@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	greg@kroah.com, joe@perches.com, randy.dunlap@oracle.com,
	trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
	When i was compiling 2.6.38.2 kernel. Something wrong happend to me.
It shows like following.

[...]
Warning: call to 'copy_from_user_overflow' declared with attribute warning:
copy_from_user buffer size is not provably correct.
[...]

See http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=report_bug.png for details.
	I tried to fix this warning, but i don't know how to deal with
it. Can anyone help me.

Thanks.
Harry Wei.
