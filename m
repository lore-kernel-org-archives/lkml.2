Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0HSQMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:12:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54662 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0HSQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YdjpTJbTelXDCCEujWZZcffxXSz7ocZzwb2xyROq9JteDTFIazylglUVjWbTOy8HuY
         KiR/5DpbqNIbX3wxDq7Wu7/I78LW80UY8hImdqLnARATxqqdWWCjUykMyBBcCv4B6ruf
         TiYSZIqLYT+l7ZmwuNAF4TIcgYPyZ1fuBZ6jU=
Subject: Re: [RFC][PATCH] introduce ptr_diff()
From: Namhyung Kim <namhyung@gmail.com>
To: Bernd Petrovitsch <bernd@sysprog.at>
Cc: Andi Kleen <andi@firstfloor.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1282233889.10440.220.camel@thorin>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
	 <87aaoiu6z6.fsf@basil.nowhere.org>  <1282233186.1713.10.camel@leonhard>
	 <1282233889.10440.220.camel@thorin>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 01:12:22 +0900
Message-ID: <1282234342.1713.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-19 (목), 18:04 +0200, Bernd Petrovitsch:
> sparse also gets gcc's parameters which include (usually) "-Wall". And
> this activates it.
> Adding -Wno-ptr-subtraction-blows to CHECKFLAGS should do the trick.
> 
> 	Bernd

I see. thanks for the info. :-)

-- 
Regards,
Namhyung Kim


