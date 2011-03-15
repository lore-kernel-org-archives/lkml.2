Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab1COJCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:02:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65338 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1COJCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=H5yJ3MXzlcz7veyHpTwrYf0HLdO1chVMVPPyN+vK2jzZTmC+5mwXEpV7nB96+bTl8R
         Kg4xECGdRSdarVFWsoYARyklvPzqsYWgcRemDc511YfU5eDWU5chWQnibcq1k0rDx2tP
         MKMV7H6eKzzmPVrpYz8fbpI7Z7LpGzhv6/c54=
MIME-Version: 1.0
From: Aneesh Bhasin <contact.aneesh@gmail.com>
Date: Tue, 15 Mar 2011 14:31:50 +0530
Message-ID: <AANLkTik3N5j74eWastminNZLevPqoSCEiVCrX1vP66_k@mail.gmail.com>
Subject: smap output - unnamed entries and heap
To: linux-newbie <linux-newbie@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

My apologies if this is not the right place for these type of
questions - I do not know of a better place to ask this.

I am trying to take out some memory figures from the /proc/<pid>/smaps
interface (linux v2.6.35). However, I could not find what do the
entries that have no name associated to them (no library path or
binary path with these entries) mean. So, I wrote a test C program
that allocates 100MB of memory (using malloc) and then writes to it in
chunks of 10MB. I could see that the 'Size' and 'RSS' of one of the
unnamed entries was increasing in accordance with the code, but there
were several other such unnamed sections too - is there a way to know
what and where do they come from.

Also, I could see that for some process the smap interface was showing
a '[heap]' entry but not for all - e.g. for my above test case, there
was no '[heap]' entry, although I assumed the malloc should have
reflected in the [heap]. Can someone please tell me (or point me in
the right direction) why is heap entry there only for some processes ?

Thanks in advance for any help..

Regards,
Aneesh Bhasin
