Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0HJDJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:09:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48929 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0HJDJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d7G4biKWcRzyBO8vu/4DqJ5zXnSbaS0EIN2XwNmtOP6x8vkZVy7rvmyH6XXZO9TiT/
         H02GspfhvnQ1nxhMU50ObNg9kAQtjgBJbdVgBJuzcblnbkQtW4/rQaPu814GPiJRP7Ln
         goJNNdOt3jjlsRXejPa2CnmmFRKwUmbsvwbno=
Subject: Re: [PATCH] sh: remove RELOC_HIDE on exception handlers and
 syscall routines
From: Namhyung Kim <namhyung@gmail.com>
To: Stuart Menefy <stuart.menefy@st.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4C601ECD.2070503@st.com>
References: <1281300825-3327-1-git-send-email-namhyung@gmail.com>
	 <4C601ECD.2070503@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 12:09:43 +0900
Message-ID: <1281409783.1670.14.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-09 (월), 16:29 +0100, Stuart Menefy:
> Unfortunately these are necessary, although it is nothing to do with linker
> relocation. These functions take a struct pt_regs as a parameter (not a
> pointer), and modify some of the fields of that structure. We needed a way
> to ensure that gcc didn't optimise away those assignments - to gcc
> they appear to be assignments to a local variable, so quite legitimately
> get optimised away. So we used RELOC_HIDE() as a way of doing that.
> 

Oh, I didn't know that. Thank you for the comments.


> A clearer way to do this would be to pass in a struct pt_regs pointer,
> but that would require going via a stub function which loads up the
> pointer.
> 
> Stuart
> 

So is it worth if I'm gonna work on it?


-- 
Regards,
Namhyung Kim


