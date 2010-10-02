Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0JBQm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:42:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38478 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0JBQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=kuz/MEPg4m0BgTZuCYmrKZFgczVRk0Dmfp+afRv0iVCETQFd5DYSF6l3SGCkyozMt2
         LAwunmRS/ZxfOoodjBCu+Q3ieX/+Tpv8+gXjp7SrEWgRYZ2WVVF7pG3/m1hnSAIis1d0
         rg16VYb1x+cWQnYScsi7eAoM3PKVePAXFuyWg=
MIME-Version: 1.0
Date: Sat, 2 Oct 2010 12:42:56 -0400
Message-ID: <AANLkTinLkZM4O66CKg+wpZ1k4k8hDQErCO3-Q-21Bps7@mail.gmail.com>
Subject: [PATCH v3 00/20]
From: T Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took another try at correcting EXTRA_CFLAGS to ccflags-y option in
most of the staging directory Makefile(s).


Thanks,
Tracey Dent
