Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0HSPxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:53:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50946 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0HSPxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PyEIwMBOyzu47Cx+wdNWUByTjN6FpLGUs+lUY5FhBxfakJ+osDWD/aLW/4K2EbQykc
         CXszebSaGakjOlgUmCF3qzztISfl2LcGAKGLRfVTxQ4bpHoLRr6ePwLrypkDTgOvE3sv
         fda+XDFz1jt3C26wRBSVS9zTnZ33XLOThoUi4=
Subject: Re: [RFC][PATCH] introduce ptr_diff()
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87aaoiu6z6.fsf@basil.nowhere.org>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
	 <87aaoiu6z6.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 00:53:06 +0900
Message-ID: <1282233186.1713.10.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-19 (목), 14:23 +0200, Andi Kleen:
> IMHO it would be better to simply disable the warning in sparse instead
> of uglying the code just to work around sparse bogosity. It doesnt' seem
> to make much sense. A subtraction followed by a shift is not expensive.
> 
> -Andi
> 

I'm curious who turns on that switch. -Wptr-subtraction-blows is turned
off by default, I didn't use CF variable at build time and I could not
find any reference of it in the source tree. Hmm..

-- 
Regards,
Namhyung Kim


