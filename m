Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab0IBTbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:31:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab0IBTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:31:50 -0400
Message-ID: <4C7FFB85.7000006@vlnb.net>
Date: Thu, 02 Sep 2010 23:31:17 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Ross Walker <rswwalker@gmail.com>
Subject: [ANNOUNCE]: Comparison of features between different SCSI targets
 (SCST, STGT, IET, LIO) updated
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:uk5b/dknlW5hHb4Nn21nyQk1KGTDCDdSLxzJntwqvzh
 srF8pATlwRkx+L9VeLihB0/CIGOmALsPGss3jb+0vvNAXZEEKB
 TvYdTzfRGifjqH7CoCbQ17U/qc8wzmTBpREq2xughPIC2/voTW
 YY+thDal06axOd2G/bnUhFOU/7KegflG+5NTZdbvxiSCEt5Vv5
 SpqUMwgPelWgIgDhX9VQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I updated the Linux SCSI targets comparison page 
http://scst.sourceforge.net/comparison.html, which compares features of 
the existing Linux SCSI target subsystems. The comparison includes SCST, 
STGT, IET and LIO. I added IET there, because it is the most used Linux 
iSCSI target at the moment.

This page is intended to be a complete and fair feature-by-feature 
comparison between the targets. The only thing I have not added there is 
quality of various corner cases recovery, because I don't know how to 
measure that. SCST is really good in this area, while some other targets 
are often not too much, but I have no idea how to summarize it in an 
objective view.

If you see I'm wrong somewhere or forgot something, you are welcome to 
correct me and I will fix that.

Vlad


