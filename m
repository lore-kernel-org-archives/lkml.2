Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab1DRHVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:21:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54069 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1DRHVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=KOuLy5M7hmbcf582BYOh+6s4T7lF6lu02iK/RDkm6OFuflpE4EQP5rkd4KkUlXLl7E
         k1aLLe2Pr03gXPW6/sfeNLgZz/HCvXJMH8GxcdVi6CIer5p6l0TygpQr6VA5J6OMYCrA
         SIZHaCmrms2uNvdvTAuJAhvYm1MYuPSzvYEfw=
MIME-Version: 1.0
In-Reply-To: <20110417180722.GA21112@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
	<20110417180722.GA21112@hallyn.com>
Date: Mon, 18 Apr 2011 16:21:05 +0900
Message-ID: <BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
From: crocket <crockabiscuit@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't like the fact that an application should be linux-specific to
keep capabilities after setuid.
If users added capabilities to a file, they would know what they were
doing, and they would want applications to keep capabilities even
after setuid.

If linux capabilities were kept after setuid by default, system
administration and programming would become easier.
