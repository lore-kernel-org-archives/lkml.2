Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0JVHfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:35:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46339 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0JVHfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BD94t/QY+XMMbWns5DWf12l339R5d3di7QN3wblKL/MnxoBzagrucwHJ/LY8EmEz0+
         xO02XcSO+ZbV+NW3m+5tXmer6B21QQyHVBXNdFIkt/wRkfMNZj+KMjFTKXs/zfVZb6tS
         oJgV7tAqFCeut2QvU28+trGNw6Hm1JnAknM+o=
MIME-Version: 1.0
Date: Fri, 22 Oct 2010 10:35:40 +0300
Message-ID: <AANLkTi=M3fpiqii_0qoZawRiZfw1=WZPOhLgKesjFaTu@mail.gmail.com>
Subject: 2.6.37-git1
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/net/wireless/hostap/hostap_cs.o
drivers/staging/comedi/drivers/ni_daq_700.c: In function ‘dio700_config’:
drivers/staging/comedi/drivers/ni_daq_700.c:499: error: ‘win_req_t’
undeclared (first use in this function)
drivers/staging/comedi/drivers/ni_daq_700.c:499: error: (Each
undeclared identifier is reported only once
drivers/staging/comedi/drivers/ni_daq_700.c:499: error: for each
function it appears in.)
drivers/staging/comedi/drivers/ni_daq_700.c:499: error: expected ‘;’
before ‘req’
drivers/staging/comedi/drivers/ni_daq_700.c:500: warning: ISO C90
forbids mixed declarations and code
