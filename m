Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab2GFLFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:05:46 -0400
Received: from csmailer.cs.nctu.edu.tw ([140.113.235.130]:63346 "EHLO
	csmailer.cs.nctu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2GFLFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:05:42 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 07:05:42 EDT
Date: Fri, 6 Jul 2012 18:55:09 +0800
From: =?utf-8?B?6Zmz6Z+L5Lu7IChXZWktUmVuIENoZW4p?= 
	<chenwj@iis.sinica.edu.tw>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH 2/7 v6] update linux headers
Message-ID: <20120706105509.GA99604@cs.nctu.edu.tw>
References: <4FF6B188.2060607@cn.fujitsu.com>
 <4FF6B232.4050502@cn.fujitsu.com>
 <4FF6BD1D.8020605@siemens.com>
 <4FF6C2E2.5020608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FF6C2E2.5020608@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Which kvm.git hash is this referring? Please state this to avoid that we
> > are merging support for kernel features that are still under review.
> 
> The following kvm.git:
> http://git.kernel.org/?p=virt/kvm/kvm.git;a=summary

  What Jia ask for is git hash, should be something like,

    8aca521512a14c439624191bd0a891c52f91b401

Regards,
chenwj

-- 
Wei-Ren Chen (陳韋任)
Computer Systems Lab, Institute of Information Science,
Academia Sinica, Taiwan (R.O.C.)
Tel:886-2-2788-3799 #1667
Homepage: http://people.cs.nctu.edu.tw/~chenwj
