Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1AaRDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:03:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55270 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab1AaRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oLu3x+wPDOFt8dHo7UDOMcQUe2XV8+BpMQ+bIScnyhFA/C8LRUWhT5Z+QHAX9SSC+/
         ygMJSy7kp8wshU/BnGxDh1cn5hLJ8B0WoSnDMGGpFAoHSCQp8UQi7WuEouihYKvvF6hJ
         CIWw8Heb8noctdoLljgj71S8bZ5QWjjOI2cuM=
MIME-Version: 1.0
Date: Mon, 31 Jan 2011 12:03:37 -0500
Message-ID: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
Subject: typecheck code
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

/*
 * Check at compile time that something is of a particular type.
 * Always evaluates to 1 so you may use it easily in comparisons.
 */
 #define typecheck(type,x) \
 ({      type __dummy; \
        typeof(x) __dummy2; \
        (void)(&__dummy == &__dummy2); \
        1; \
 })

#define typecheck_fn(type,function) \
({      typeof(type) __tmp = function; \
       (void)__tmp; \
})

Can anyone help me, explain the above code typecheck. How does
(void)(&__dummy == &__dummy2) evaluates to 1

I appreciate any explain.

-- 
Regards,
Sri.
