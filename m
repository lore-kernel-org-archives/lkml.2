Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0FWA01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 20:26:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56283 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0FWA0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 20:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gY4yuMfOXAT7DBjdV0vtCCKA1aqXqtz/akQ6jTeIGZmY12xj3lx+pJGZEKb57ec0yo
         It+j1AwnnS7K6/YQe/0RzJ1u6CmKVGBqYKLySxP9PhOQMSsc3PUgWJwBbjgdlQE1ZYJ0
         zHzbkB4J56Rws+QGjZnxsaxTmBN9Y17AMq6JA=
MIME-Version: 1.0
Date: Wed, 23 Jun 2010 09:26:24 +0900
Message-ID: <AANLkTimxGK93hnV9-jGZAeeJ_JnrWCTaq-dkDvfUW6St@mail.gmail.com>
Subject: SO_REUSEPORT
From: Tim Prepscius <timprepscius@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings gods of the linux kernel,

Is SO_REUSEPORT available 2.6.ish - (or any version)?
I've been searching for a conclusive answer to this question and can't
find it.

(yes I know of SO_REUSEADDR, and I know the difference between this
and *PORT, and yes I know that I *definitely* need SO_REUSEPORT, no,
I'm unconcerned this may/may not be part of a "standard," yes I know
it is implemented differently on different systems, yes I know there
may be security problems, but no, I don't care about this.)


If it's not, are there any patches available which might enable it?

Could you point me in the right direction to find these patches?
Google/Bing seem to be failing me, and/or I'm picking the wrong/
unlucky search terms.


Thanks a lot!

-tim
